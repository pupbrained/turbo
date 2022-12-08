{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  fontconfig,
  freetype,
  pkgs,
}:
rustPlatform.buildRustPackage rec {
  pname = "turbo-tooling";
  version = "1.6.0";

  src = ./.;
  cargoSha256 = "n2zr8437yYU613/PBkEzg6MBuEAzghPi+lzLTTYbGho=";
  nativeBuildInputs = [
    pkg-config
    pkgs.rust-bin.nightly.latest.default
  ];

  preConfigure = ''
    export PKG_CONFIG_PATH="${fontconfig.dev}/lib/pkgconfig:${freetype.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
  '';

  doCheck = false;

  meta = with lib; {
    description = "Incremental bundler and build system optimized for JavaScript and TypeScript, written in Rust – including Turborepo and Turbopack.";
    homepage = "https://turbo.build/";
    license = licenses.unlicense;
    maintainers = [maintainers.tailhook];
  };
}
