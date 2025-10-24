# design for godot gamedev

overall personal notes ive been taking for game design, when completed this will be part of the godot-shell templates automatically
first with notes, then with a pragmatic wiki for generating objects in various game engines

## modules

examples of modules to make to create a full game
it's by no means complete or a full list as needs of a game can change over time and per game
additionally alot of game engines include systems for these modules

rules:

- don't over optimise: build systems first before deciding if it should be a generic

- playercontroller — Handles player movement, input, and physics abstraction.
- cameracontroller — Manages camera rigs, transitions, and virtual camera systems.
- uisystem — Provides UI framework, view management, and data binding.
- eventbus — Global pub/sub system for decoupled communication.
- gamesystem — Core game loop, states (menu, gameplay, pause), and mode management.
- inputsystem — Unified input abstraction (keyboard, gamepad, touch).
- audiosystem — Centralized audio routing, mixer control, and playback events.
- savesystem — Handles player data persistence, serialization, and versioning.
- scenesystem — Manages scene loading, additive transitions, and bootstrapping.
- inventorysystem — Manages items, equipment, and consumables.
- combatsystem — Handles hit detection, damage, and health logic.
- aisystem — Framework for agents, pathfinding, and decision trees.
- uilocalization — Text and UI localization with language switching.
- settingssystem — Stores and applies player preferences (graphics, input, audio).
- missionsystem — Quest and task progression management.
- dialogsystem — Conversation flow, branching dialogue, and UI integration.
- interactionsystem — Detects and routes player interactions with world objects.
- physicshelpers — Shared utilities for raycasts, layers, and physics events.
- vfxsystem — Particle, shader, and screen effect orchestration.
- timesystem — Global time scaling, pausing, and timers.
- networking — Multiplayer sync, lobby, and RPC abstractions.
- analytics — Tracks player metrics and gameplay events.
- debugtools — Developer console, gizmos, and runtime profiling.
- dependencyinjection — Provides IoC container and service registration.
- datamodels — Shared data structures, configuration assets, and serializable types.
- buildpipeline — CI/CD build scripts, versioning, and packaging automation.

## concepts

### performance

rendering:

[video here](https://youtu.be/CHYxjpYep_M?si=wlTj3uA7NHOsa6AL)
1. frustum culling - camera "frustum" bounds dictating what the game renders
2. occulsion culling - game object bounds dictating what the game renders
3. depth buffers (zed buffers / hzb's) - specialized occulsion culling
