# wiki / design notes

overall personal notes ive been taking for game design, when completed this will be part of the godot-shell templates automatically
first with notes, then with a pragmatic wiki for generating objects in various game engines

## what is needed to build a game?

environment:

- dependencies (nix, programs, versions, art)
- version control (git, dvc)
- ci/cd - github actions, test, versioning, conventional commits, branches, release

art:

- textures
- models
- sound

design:

- storybooking, moodboard (obsidian)
- concept art (some sort of drawing pad, paper, obsidian, krita)
- design document
- scoping
- project management
- roadmapping

development:

- systems design
- building
- anti-piracy

marketing:

- video editing
- scheduling posts

release:

## [components](./components/README.md)

`./components` folder is WIP, alot of docs need to be pruned, generally the components list is alright

## performance

## rendering

[video here](https://youtu.be/CHYxjpYep_M?si=wlTj3uA7NHOsa6AL)

1. frustum culling - camera "frustum" bounds dictating what the game renders
2. occulsion culling - game object bounds dictating what the game renders
3. depth buffers (zed buffers / hzb's) - specialized occulsion culling

## modeling

## pixel art

[video here](https://youtu.be/DKmrBUpd0yw)
