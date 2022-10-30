{ lib, buildGoModule, protobuf, protoc-gen-go, protoc-gen-go-grpc }:

buildGoModule rec {
  pname = "turborepo";
  version = "1.6.0";

  src = ./cli;

  vendorSha256 = "Kx/CLFv23h2TmGe8Jwu+S3QcONfqeHk2fCW1na75c0s=";
  nativeBuildInputs = [
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
  ];

  preBuild = ''
    make compile-protos
  '';

  doCheck = false;

  meta = with lib; {
    description = "Incremental bundler and build system optimized for JavaScript and TypeScript, written in Rust – including Turborepo and Turbopack.";
    homepage = "https://turbo.build/";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
