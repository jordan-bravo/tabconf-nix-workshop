{
  description = "TABConf Nix Workshop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        defaultPackage = pkgs.rustPlatform.buildRustPackage {
          pname = "nix-workshop";
          version = "0.1.0";

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          src = ./.;
          buildInputs = [
            pkgs.rustc
            pkgs.cargo
            pkgs.bitcoind
          ];

          preBuild = ''
            mkdir -p $out/data
            ${pkgs.bitcoind}/bin/bitcoind -regtest -daemon -datadir=$out/data
          '';
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bitcoind
            cargo
            rustc
          ];
          shellHook = ''
            ${pkgs.bitcoind}/bin/bitcoind regtest -daemon
          '';
        };
      });
}
