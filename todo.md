# todo

## next

- test a few projects and understand the files it creates, use a simple 2d and 3d template

- reference chicken game template, code coverage might be cool to steal
- better asset detection in scripts, use an actual git ignore file
  - [for images as an example](https://github.com/github/gitignore/blob/main/Global/Images.gitignore)

- self hosted github action runner
- revise the project template and addon template
- addon template should be templated and a script should be made to quickly edit the contents

## backlog

- hello world impl for addon and importing guide
- setup commitlint, semantic-release, git hooks, and github actions for these
  - for both project and addon, some scripting might help

### lower priority

- better vscode extension recommendations

## unsure

- automate dvc merge conflict asset comparison (checkout and cp)
- templating scripts for variables like project name, author, etc.

- list of recommended addons i should have by default
  - all
    - something
  - 2d
    - something
  - 3d
    - something

initial addons?:

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
