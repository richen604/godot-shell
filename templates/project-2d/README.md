# godot 2d project template

a streamlined 2d project template with automated asset management for rapid prototyping and game jams.

## what you get

- standardized godot project structure
- automated large asset handling via dvc and git hooks
- nix development environment for consistent tooling
- open source alternative to perforce/git lfs workflows

## getting started

### 1. setup your environment

ensure you have these installed:

- nix (with flakes support recommended)
- direnv

### 2. initialize the project

```bash
# copy this template to your project directory
mkdir your-game-name
nix flake init -t github:richen604/godot-shell/#project-2d

# allow direnv to setup the development environment
direnv allow

# shell will automatically initialize git and dvc with hooks
```

### 3. understand asset management

this template automatically manages large assets through git hooks and dvc:

- **what it does**: scans commits for large files and assets typically git-ignored
- **why it helps**: keeps all assets version controlled without bloating your repository, skips your need to run dvc commands manually
- **how it works**: large assets are tracked by dvc, pushed remotely, but remain accessible to your team

when you commit large assets (textures, models, audio), the hooks will:

1. detect files over the size threshold
2. automatically add them to dvc tracking
3. commit the lightweight dvc pointer files instead
4. keep your repository fast while maintaining full asset history

youll want to check out the [dvc docs](https://dvc.org/doc) for more information on how to use dvc.

first, you'll want to setup a remote for your project (below is an example):

```bash
# initialize a remote for your project
dvc remote add -d myremote https://myremote.com/myrepo
```

### 4. start developing

your godot project is ready to go. open godot and point it to this directory to begin development.

## project structure

TODO

## helpful resources

### assets

- [kenney.nl](https://kenney.nl/assets/) - free game assets
- [opengameart.org](https://opengameart.org/) - community game assets

### godot documentation

- [godot docs](https://docs.godotengine.org/) - official documentation
- [godot tutorials](https://docs.godotengine.org/en/stable/getting_started/introduction/index.html) - getting started guide
