# godot-shell

a collection of godot project templates with automated asset management and nix development environments.

## available templates

### project-2d

2d project template with automated asset handling and development tooling.

### project-3d

3d project template with automated asset handling and development tooling.

## quick start

```bash
# choose your template
nix flake init -t github:richen604/godot-shell/#project-2d
# or
nix flake init -t github:richen604/godot-shell/#project-3d

# setup environment
direnv allow
```

## what you get

- **automated asset management**: dvc integration with git hooks for seamless large file handling
- **open source workflow**: alternative to proprietary asset management solutions
- **consistent environments**: nix flakes ensure reproducible development setups
- **godot-ready structure**: standardized project layouts optimized for different game types

## requirements

- nix (with flakes support)
- direnv
- godot engine

## templates overview

each template includes:

- pre-configured godot project structure
- automated dvc setup for asset version control
- development environment with necessary tooling
- git hooks for seamless large file management
- template-specific optimizations and configurations

check individual template directories for detailed setup instructions and features.

## contributing

feel free to submit issues and pull requests to improve the templates or add new ones.

## todo

see [todo.md](todo.md) for a list of planned features and improvements.
