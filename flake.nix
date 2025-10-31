{
  description = "A Nix-managed Godot project flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { ... }@inputs:
    {

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
