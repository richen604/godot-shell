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
          description = "A basic Godot project";
        };
        project-3d = {
          path = ./templates/project-3d;
          description = "A basic Godot 3d project";
        };
      };
    };
}
