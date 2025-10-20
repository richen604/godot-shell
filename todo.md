# todo

## next

- test a few projects and understand the files it creates, use a simple 2d and 3d template
- list of recommended addons i should have by default
  - all
    - something
  - 2d
    - something
  - 3d
    - something
- reference chicken game template, code coverage might be cool to steal

- self hosted github action runner
- external assets symlinking scripts
- revise the project template and addon template
- addon template should be templated and a script should be made to quickly edit the contents

## backlog

- hello world impl for addon and importing guide
- setup commitlint, semantic-release, git hooks, and github actions for these
  - for both project and addon, some scripting might help

### lower priority

- better vscode extension recommendations

## unsure

- templating scripts for variables like project name, author, etc.

initial addons?:

- take a look at the asset library for some free stuff
- godot-tween or create_tween() (built-in tweening)
- phantom camera or custom camera controller (for camera management)
- godot input system (built-in input handling)
- godot's built-in rich text label and font system
- audio: simple audio manager for sfx/bgm using AudioStreamPlayer
- runtime level editor (if applicable)
- debug utilities (e.g., in-game console)
- common gdscript templates (node scripts, resource scripts)
- base scene setup (main camera, light, input handling)
- common scene components (player, ui elements)
- ci: godot test framework setup (gut or gdunit4)

ai integration:

- godot-mcp?

## build & deployment

- **build automation:**
  - scripted exports for windows, linux, web
  - custom export pipeline for faster iterations
- **deployment tools:**
  - itch.io upload script (butler?)
  - steam upload script (butler?)
- **web optimization:**
  - default web export settings for performance/size

## game jam specific features

- **scene management:**
  - simple scene loader/manager
- **ui systems:**
  - basic main menu, pause menu, game over screens
  - settings menu (volume, controls)
- **input management:**
  - rebindable controls via input map system
- **data persistence:**
  - simple save/load system
- **feedback & debugging:**
  - screenshot/gif recorder
  - simple in-game debug console

## nix - further enhancements

- **fhs environment for godot:**
  - research and integrate `godot-fhs-env` wrapper
  - configure `direnv` to automatically pull in the godot editor and environment
- **gpu acceleration:**
  - verify and document gpu acceleration setup for godot editor under nix
- **declarative godot editors:**
  - explore options for declarative installation of specific godot editor versions
- **additional libraries/tools:**
  - integrate more nix packages useful for game development (e.g., image manipulation tools, audio tools)
- **documentation:**
  - comprehensive nix setup guide for godot
  - explain how to manage different godot versions with nix
