{
  description = "Turbo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    fenix,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        overlays = [
          fenix.overlays.default
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in rec {
        packages = flake-utils.lib.flattenTree {
          turbo = pkgs.callPackage ./turbo.nix {};
          turbo-tooling = pkgs.rustPlatform.buildRustPackage rec {
            pname = "turbo-tooling";
            version = "1.6.0";

            src = ./.;
            cargoSha256 = "n2zr8437yYU613/PBkEzg6MBuEAzghPi+lzLTTYbGho=";
            nativeBuildInputs = [
              pkgs.pkg-config
              (fenix.minimal.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
            ];

            preConfigure = ''
              export PKG_CONFIG_PATH="${pkgs.fontconfig.dev}/lib/pkgconfig:${pkgs.freetype.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
            '';

            doCheck = false;

            meta = with pkgs.lib; {
              description = "Incremental bundler and build system optimized for JavaScript and TypeScript, written in Rust – including Turborepo and Turbopack.";
              homepage = "https://turbo.build/";
              license = licenses.unlicense;
              maintainers = [maintainers.tailhook];
            };
          };
        };
        defaultPackage = packages.turbo;
        apps.turbo = flake-utils.lib.mkApp {drv = packages.turbo;};
        defaultApp = apps.turbo;
      }
    );
}
