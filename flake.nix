{
  description = "Nix flake for PokeMMO Client DDL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      sources = builtins.fromJSON (builtins.readFile ./pkgs/sources.json);

      overlay = final: prev: {
        pokemmo = prev.callPackage ./pkgs/default.nix {
          inherit (sources) url sha256;
        };
      };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlay ];
      };
    in
    {
      overlays.default = overlay;

      packages.${system}.default = pkgs.pokemmo;

      apps.${system}.default = {
        type = "app";
        program = "${pkgs.pokemmo}/bin/pokemmo";
      };
    };
}
