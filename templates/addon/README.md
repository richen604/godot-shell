# godot addon template

This is a basic template for creating a Godot Engine addon.

## usage

1. `nix flake init -t github:richen604/godot-shell/#addon` the project into your Godot project's `addons/new-addon-name` directory.
2. Enable the plugin in Project Settings -> Plugins.

## structure

- `./plugin.cfg`: Plugin configuration.
- `./plugin.gd`: Main plugin script.
- `./icons/`: Custom icons for the addon.
- `./scenes/`: Reusable scenes/nodes.
- `./scripts/`: GDScript files.
- `./resources/`: Custom resources.

## what you get

- [dvc](https://dvc.org/) for asset version control
  - automated with git hooks
- [nix](https://nixos.org/) for reproducible development environments
  - with [direnv](https://direnv.net/) for automatic environment setup
- [godotenv](https://github.com/chickensoft-games/GodotEnv) for managing godot addons

## getting started

### dvc - asset version control

`godot-shell` uses [dvc](https://dvc.org/) for asset version control, automated with git hooks
see `./.git/hooks/pre-commit` for implementation

what it does:

- detects files over the size threshold
- automatically adds them to dvc tracking
- commits the lightweight dvc pointer files instead
- keeps your repository fast while maintaining full asset history
- all of this is done automatically with git hooks

by default the dvc remote is set locally to `./.dvc-storage`
you probably want to update this to the remote of your choice in `.dvc/config` [see docs](https://dvc.org/doc/user-guide/data-management/remote-storage#remote-storage)

### godotenv - godot addons management

`godot-shell` uses [godotenv](https://github.com/chickensoft-games/GodotEnv) for managing godot addons

what it does:

- downloads and installs addons from git repositories
- centralizes addon configuration in `addons.jsonc`
- can support a global addons directory for space efficiency
  
see `./addons.jsonc` for configuration, see [godotenv docs](https://github.com/chickensoft-games/GodotEnv) for more info

you probably want to update the `path` and `cache` fields in `./addons.jsonc` to the path of your choice
`addons/` and `./.addons` are the defaults and are automatically added to `.gitignore` for you

## helpful resources

### assets

- [kenney.nl](https://kenney.nl/assets/) - free game assets
- [opengameart.org](https://opengameart.org/) - community game assets

### godot documentation

- [godot docs](https://docs.godotengine.org/) - official documentation
- [godot tutorials](https://docs.godotengine.org/en/stable/getting_started/introduction/index.html) - getting started guide
- [godot asset library](https://godotengine.org/asset-library/asset) - asset library
- [godot-demo-projects](https://github.com/godotengine/godot-demo-projects) - offical demo projects, good for inspiration / best practices
