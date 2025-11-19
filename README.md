# godot-shell

everything a solo game developer needs in one environment.

beyond code - design docs, project management, art, sound, marketing, and deployment tools for production-ready games.

## templates overview

- [project-3d](./templates/project-3d/README.md) - 3d project template
- [addon](./templates/addon/README.md) - godot addon template

## quick start

```bash
nix flake init -t github:richen604/godot-shell/#project-3d
# or
nix flake init -t github:richen604/godot-shell/#addon

# setup environment
direnv allow
```

## what you get

- [dvc](https://dvc.org/) for asset version control
  - automated with git hooks
- [nix](https://nixos.org/) for reproducible development environments
  - with [direnv](https://direnv.net/) for automatic environment setup
- [godotenv](https://github.com/chickensoft-games/GodotEnv) for managing godot addons

## requirements

- nix (with flakes support)
- direnv (optional but recommended)

## contributing

feel free to submit issues and pull requests to improve the templates or add new ones.

## todo

see [todo.md](todo.md) for a list of planned features and improvements.
