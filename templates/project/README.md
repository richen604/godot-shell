# godot 3d project template

a streamlined 3d project template with automated asset management for rapid prototyping and game jams.

## what you get

- [git-lfs](https://git-lfs.com/) for asset version control
  - automated with git hooks
- [nix](https://nixos.org/) for reproducible development environments
  - with [direnv](https://direnv.net/) for automatic environment setup
- [godotenv](https://github.com/chickensoft-games/GodotEnv) for managing and creating godot addons

### godotenv - godot addons management

[godotenv](https://github.com/chickensoft-games/GodotEnv) for managing godot addons

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
