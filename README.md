# godot-shell

everything a solo game developer needs in one environment.

beyond code - design docs, project management, art, sound, marketing, and deployment tools for production-ready games.

## templates overview

- [project](./templates/project/README.md) - generic project template

## quick start

```bash
nix flake init -t github:richen604/godot-shell/#project

# setup environment
direnv allow
```

## what you get

- [git-lfs](https://git-lfs.com/) for asset version control
  - automated with git hooks
- [nix](https://nixos.org/) for reproducible development environments
  - with [direnv](https://direnv.net/) for automatic environment setup
- [godotenv](https://github.com/chickensoft-games/GodotEnv) for managing godot addons

## requirements

- nix (with flakes support)
- direnv (optional but recommended)

## contributing

feel free to submit issues and pull requests to improve the templates or add new ones.
