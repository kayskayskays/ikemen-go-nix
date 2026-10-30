{
  description = "Ikemen GO fighting game engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      ikemen-go = pkgs.callPackage ./package.nix { inherit pkgs; };
    in
    {
      packages.${system} = {
        inherit ikemen-go;
        default = ikemen-go;
      };

      formatter.${system} = pkgs.nixfmt-tree;
    };
}
