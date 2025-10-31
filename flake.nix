{
  description = "A Nix-managed Godot project flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          godotenv = pkgs.callPackage ./pkgs/godotenv.nix { };
        }
      );

      templates = {
        default = {
          path = ./templates/project-3d;
          description = "A basic godot 3d project";
        };
        project-3d = {
          path = ./templates/project-3d;
          description = "A basic godot 3d project";
        };
        addon = {
          path = ./templates/addon;
          description = "A basic godot addon";
        };
      };
    };
}
