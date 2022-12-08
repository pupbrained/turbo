{
  description = "Turbo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        overlays = [(import rust-overlay)];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in rec {
        packages = flake-utils.lib.flattenTree {
          turbo = pkgs.callPackage ./turbo.nix {};
          turbo-tooling = pkgs.callPackage ./tooling.nix {};
        };
        defaultPackage = packages.turbo;
        apps.turbo = flake-utils.lib.mkApp {drv = packages.turbo;};
        defaultApp = apps.turbo;
      }
    )
    // {
      overlay = final: prev: {
        turbo = final.callPackage ./turbo.nix {};
        turbo-tooling = final.callPackage ./tooling.nix {};
      };
    };
}
