# components

- [components](#components)
  - [core movement \& physics components](#core-movement--physics-components)
    - [velocitycomponent (2d/3d)](#velocitycomponent-2d3d)
    - [movementcomponent (2d/3d)](#movementcomponent-2d3d)
    - [jumpcomponent (2d/3d)](#jumpcomponent-2d3d)
    - [dashcomponent (2d/3d)](#dashcomponent-2d3d)
  - [combat \& interaction components](#combat--interaction-components)
    - [healthcomponent (2d/3d)](#healthcomponent-2d3d)
    - [hurtboxcomponent (2d/3d)](#hurtboxcomponent-2d3d)
    - [hitboxcomponent (2d/3d)](#hitboxcomponent-2d3d)
    - [weaponcomponent (2d/3d)](#weaponcomponent-2d3d)
    - [interactablecomponent (2d/3d)](#interactablecomponent-2d3d)
  - [ai \& behavior components](#ai--behavior-components)
    - [pathfindcomponent (2d/3d)](#pathfindcomponent-2d3d)
    - [followcomponent (2d/3d)](#followcomponent-2d3d)
    - [patrolcomponent (2d/3d)](#patrolcomponent-2d3d)
    - [detectioncomponent (2d/3d)](#detectioncomponent-2d3d)
    - [statemachinecomponent (2d/3d)](#statemachinecomponent-2d3d)
  - [visual \& ui components](#visual--ui-components)
    - [healthbarcomponent (2d)](#healthbarcomponent-2d)
    - [floatingtextcomponent (2d/3d)](#floatingtextcomponent-2d3d)
    - [blinkcomponent (2d/3d)](#blinkcomponent-2d3d)
    - [lookatcomponent (2d/3d)](#lookatcomponent-2d3d)
  - [audio \& effects components](#audio--effects-components)
    - [audiocomponent (2d/3d)](#audiocomponent-2d3d)
    - [particlecomponent (2d/3d)](#particlecomponent-2d3d)
    - [screenshakecomponent (2d/3d)](#screenshakecomponent-2d3d)
  - [utility \& system components](#utility--system-components)
    - [timercomponent (2d/3d)](#timercomponent-2d3d)
    - [savecomponent (2d/3d)](#savecomponent-2d3d)
    - [poolcomponent (2d/3d)](#poolcomponent-2d3d)
    - [spawnercomponent (2d/3d)](#spawnercomponent-2d3d)
  - [rpg \& character progression components](#rpg--character-progression-components)
    - [statscomponent (2d/3d)](#statscomponent-2d3d)
    - [inventorycomponent (2d/3d)](#inventorycomponent-2d3d)
    - [experiencecomponent (2d/3d)](#experiencecomponent-2d3d)
    - [questcomponent (2d/3d)](#questcomponent-2d3d)
    - [dialoguecomponent (2d/3d)](#dialoguecomponent-2d3d)
    - [skilltreecomponent (2d/3d)](#skilltreecomponent-2d3d)
  - [racing \& vehicle components](#racing--vehicle-components)
    - [vehiclephysicscomponent (3d)](#vehiclephysicscomponent-3d)
    - [tirecomponent (3d)](#tirecomponent-3d)
    - [laptimercomponent (2d/3d)](#laptimercomponent-2d3d)
    - [trackcomponent (3d)](#trackcomponent-3d)
    - [pitstopcomponent (3d)](#pitstopcomponent-3d)
  - [advanced visual \& environment components](#advanced-visual--environment-components)
    - [weathercomponent (2d/3d)](#weathercomponent-2d3d)
    - [daynightcomponent (2d/3d)](#daynightcomponent-2d3d)
    - [terraincomponent (3d)](#terraincomponent-3d)
    - [biomecomponent (2d/3d)](#biomecomponent-2d3d)
    - [lodcomponent (3d)](#lodcomponent-3d)
    - [cullingcomponent (3d)](#cullingcomponent-3d)
  - [procedural generation components](#procedural-generation-components)
    - [noisecomponent (2d/3d)](#noisecomponent-2d3d)
    - [chunkcomponent (2d/3d)](#chunkcomponent-2d3d)
    - [dungeongeneratorcomponent (2d/3d)](#dungeongeneratorcomponent-2d3d)
    - [wavecollapsecomponent (2d/3d)](#wavecollapsecomponent-2d3d)
    - [lsystemcomponent (2d/3d)](#lsystemcomponent-2d3d)
  - [performance \& optimization components](#performance--optimization-components)
    - [batchingcomponent (2d/3d)](#batchingcomponent-2d3d)
    - [streamingcomponent (2d/3d)](#streamingcomponent-2d3d)
    - [cachecomponent (2d/3d)](#cachecomponent-2d3d)
    - [profilercomponent (2d/3d)](#profilercomponent-2d3d)
  - [ecs \& data-driven components](#ecs--data-driven-components)
    - [entitycomponent (2d/3d)](#entitycomponent-2d3d)
    - [transformdatacomponent (2d/3d)](#transformdatacomponent-2d3d)
    - [renderdatacomponent (2d/3d)](#renderdatacomponent-2d3d)
    - [physicsdatacomponent (2d/3d)](#physicsdatacomponent-2d3d)
    - [systemmanagercomponent (2d/3d)](#systemmanagercomponent-2d3d)
  - [multiplayer \& networking components](#multiplayer--networking-components)
    - [networksynccomponent (2d/3d)](#networksynccomponent-2d3d)
    - [authoritycomponent (2d/3d)](#authoritycomponent-2d3d)
    - [networkspawnercomponent (2d/3d)](#networkspawnercomponent-2d3d)
    - [replicationcomponent (2d/3d)](#replicationcomponent-2d3d)
    - [lagcompensationcomponent (2d/3d)](#lagcompensationcomponent-2d3d)
    - [voicechatcomponent (2d/3d)](#voicechatcomponent-2d3d)
  - [production \& system components](#production--system-components)
    - [settingscomponent (2d/3d)](#settingscomponent-2d3d)
    - [localizationcomponent (2d/3d)](#localizationcomponent-2d3d)
    - [achievementcomponent (2d/3d)](#achievementcomponent-2d3d)
    - [cloudsavecomponent (2d/3d)](#cloudsavecomponent-2d3d)
    - [analyticscomponent (2d/3d)](#analyticscomponent-2d3d)
    - [inputremapcomponent (2d/3d)](#inputremapcomponent-2d3d)
    - [audiomixercomponent (2d/3d)](#audiomixercomponent-2d3d)
    - [screenshotcomponent (2d/3d)](#screenshotcomponent-2d3d)

## core movement & physics components

### velocitycomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: manages velocity calculations.
- implementation: custom node with exported variables for max_speed, acceleration, friction.
- methods: `accelerate_in_direction()`, `apply_friction()`, `get_velocity()`
- signals: none (pure data component)
- dependencies: none

### movementcomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: applies velocity to CharacterBody2D/3D movement.
- implementation: connects to VelocityComponent, handles move_and_slide().
- methods: `move()`, `set_velocity_component()`
- signals: `moved`, `collision_detected`
- dependencies: VelocityComponent

### jumpcomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: handles jumping mechanics with gravity.
- implementation: modifies velocity for jump behavior.
- methods: `jump()`, `is_on_ground()`, `apply_gravity()`
- signals: `jumped`, `landed`
- dependencies: VelocityComponent

### dashcomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: provides dash/dodge mechanics.
- implementation: temporary velocity boost with cooldown.
- methods: `dash()`, `can_dash()`, `set_dash_direction()`
- signals: `dash_started`, `dash_ended`
- dependencies: VelocityComponent

## combat & interaction components

### healthcomponent (2d/3d)

- difficulty: 1/5 (beginner)
- purpose: tracks max/current health, handles damage/healing.
- implementation: custom node with exported max_health.
- methods: `take_damage()`, `heal()`, `get_health_percentage()`
- signals: `health_changed`, `health_depleted`, `healed`
- dependencies: none

### hurtboxcomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: detects incoming damage and applies to HealthComponent.
- implementation: Area2D/3D with CollisionShape2D/3D child.
- methods: `set_health_component()`, `enable()`, `disable()`
- signals: `hurt`, `area_entered`
- dependencies: HealthComponent, CollisionShape2D/3D

### hitboxcomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: deals damage to HurtBoxComponents.
- implementation: Area2D/3D that detects HurtBoxes.
- methods: `set_damage()`, `enable()`, `disable()`
- signals: `hit_target`
- dependencies: CollisionShape2D/3D

### weaponcomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: manages weapon stats and firing mechanics.
- implementation: handles damage, fire rate, ammo, projectile spawning.
- methods: `fire()`, `reload()`, `can_fire()`
- signals: `fired`, `reloaded`, `ammo_empty`
- dependencies: none

### interactablecomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: enables objects to be interacted with by player.
- implementation: Area2D/3D that detects player proximity.
- methods: `interact()`, `set_interaction_text()`
- signals: `player_entered`, `player_exited`, `interacted`
- dependencies: CollisionShape2D/3D

## ai & behavior components

### pathfindcomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: navigates toward targets using pathfinding.
- implementation: uses NavigationAgent2D/3D.
- methods: `set_target()`, `get_next_path_position()`, `is_navigation_finished()`
- signals: `target_reached`, `path_changed`
- dependencies: VelocityComponent, NavigationAgent2D/3D
- performance note: ⚠️ pathfinding can be expensive with complex navigation meshes. limit pathfinding updates to 5-10 times per second instead of every frame. use `set_target_desired_distance()` to reduce recalculation frequency. for many ai entities, consider staggering pathfinding updates across frames.

### followcomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: makes entity follow a target at specified distance.
- implementation: calculates direction to target, maintains distance.
- methods: `set_target()`, `set_follow_distance()`, `update_follow()`
- signals: `target_lost`, `target_in_range`
- dependencies: VelocityComponent

### patrolcomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: moves entity between predefined waypoints.
- implementation: cycles through waypoint array.
- methods: `add_waypoint()`, `start_patrol()`, `pause_patrol()`
- signals: `waypoint_reached`, `patrol_completed`
- dependencies: PathfindComponent or VelocityComponent

### detectioncomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: detects targets within range/line of sight.
- implementation: Area2D/3D with optional raycast.
- methods: `add_target_group()`, `get_detected_targets()`, `has_line_of_sight()`
- signals: `target_detected`, `target_lost`
- dependencies: CollisionShape2D/3D, optional RayCast2D/3D

### statemachinecomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: manages entity states and transitions.
- implementation: dictionary of states with transition logic.
- methods: `change_state()`, `get_current_state()`, `add_state()`
- signals: `state_changed`, `state_entered`, `state_exited`
- dependencies: none

## visual & ui components

### healthbarcomponent (2d)

- difficulty: 2/5 (easy)
- purpose: visual representation of health.
- implementation: ProgressBar or TextureProgressBar.
- methods: `update_health()`, `set_health_component()`
- signals: none
- dependencies: HealthComponent

### floatingtextcomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: shows damage numbers or status text.
- implementation: Label with tween animation.
- methods: `show_text()`, `set_color()`, `animate_float()`
- signals: `animation_finished`
- dependencies: none

### blinkcomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: makes sprite blink when taking damage.
- implementation: modulates sprite alpha with timer.
- methods: `start_blink()`, `stop_blink()`, `set_blink_duration()`
- signals: `blink_finished`
- dependencies: Sprite2D/3D or MeshInstance3D

### lookatcomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: rotates entity to face target or mouse.
- implementation: calculates angle to target and applies rotation.
- methods: `look_at_target()`, `look_at_mouse()`, `set_target()`
- signals: none
- dependencies: none

## audio & effects components

### audiocomponent (2d/3d)

- difficulty: 1/5 (beginner)
- purpose: manages sound effects for entity.
- implementation: AudioStreamPlayer with sound library.
- methods: `play_sound()`, `stop_sound()`, `set_volume()`
- signals: `sound_finished`
- dependencies: AudioStreamPlayer

### particlecomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: spawns particle effects for events.
- implementation: GPUParticles2D/3D with effect presets.
- methods: `play_effect()`, `stop_effect()`, `set_effect_type()`
- signals: `effect_finished`
- dependencies: GPUParticles2D/3D
- performance note: ⚠️ use GPUParticles2D/3D for persistent effects (fire, smoke) and CPUParticles2D/3D for one-shot effects (explosions, impacts). GPUParticles are faster but have initialization overhead. limit total particle count to 5000-10000 on screen. use `one_shot` mode and object pooling for frequently spawned effects.

### screenshakecomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: applies camera shake effects.
- implementation: modifies camera position with noise.
- methods: `shake()`, `set_intensity()`, `stop_shake()`
- signals: `shake_finished`
- dependencies: Camera2D/3D

## utility & system components

### timercomponent (2d/3d)

- difficulty: 1/5 (beginner)
- purpose: manages multiple named timers for entity.
- implementation: dictionary of Timer nodes.
- methods: `start_timer()`, `stop_timer()`, `is_timer_active()`
- signals: `timer_timeout`
- dependencies: Timer nodes

### savecomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: handles saving/loading entity data.
- implementation: serializes component data to dictionary.
- methods: `save_data()`, `load_data()`, `get_save_dict()`
- signals: `data_saved`, `data_loaded`
- dependencies: none

### poolcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: object pooling for projectiles/effects.
- implementation: array of reusable objects.
- methods: `get_pooled_object()`, `return_to_pool()`, `expand_pool()`
- signals: `pool_expanded`
- dependencies: none
- performance note: ✅ this component improves performance. essential for frequently spawned objects (bullets, particles, enemies). eliminates instantiation/deletion overhead which causes frame drops. pre-allocate pool size based on max expected objects. can improve spawn performance by 10-100x. use for any object spawned more than 10 times per second.

### spawnercomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: spawns entities at intervals or on events.
- implementation: instantiates scenes with spawn logic.
- methods: `spawn()`, `set_spawn_scene()`, `start_auto_spawn()`
- signals: `entity_spawned`
- dependencies: timer (optional)

## rpg & character progression components

### statscomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: manages character attributes and derived stats.
- implementation: pure data container with exported base stats and calculated modifiers.
- methods: `get_stat()`, `add_modifier()`, `remove_modifier()`, `calculate_derived_stats()`
- signals: `stat_changed`, `modifier_added`, `modifier_removed`
- dependencies: none

### inventorycomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: manages item storage with slots and weight limits.
- implementation: array of item slots with metadata (stack size, weight, rarity).
- methods: `add_item()`, `remove_item()`, `has_item()`, `get_items_by_type()`, `sort_inventory()`
- signals: `item_added`, `item_removed`, `inventory_full`, `item_used`
- dependencies: none

### experiencecomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: handles experience points and leveling system.
- implementation: tracks current xp, level, and xp requirements per level.
- methods: `add_experience()`, `level_up()`, `get_level_progress()`, `set_level_curve()`
- signals: `experience_gained`, `level_up`, `skill_point_gained`
- dependencies: StatsComponent (optional)

### questcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: manages quest objectives and progress tracking.
- implementation: dictionary of active quests with objective states.
- methods: `start_quest()`, `complete_objective()`, `abandon_quest()`, `get_quest_progress()`
- signals: `quest_started`, `objective_completed`, `quest_completed`, `quest_failed`
- dependencies: none

### dialoguecomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: handles conversation trees and npc interactions.
- implementation: json/resource-based dialogue trees with branching logic.
- methods: `start_dialogue()`, `choose_option()`, `end_dialogue()`, `set_dialogue_tree()`
- signals: `dialogue_started`, `dialogue_ended`, `option_selected`, `dialogue_progressed`
- dependencies: none

### skilltreecomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: manages unlockable abilities and skill progression.
- implementation: graph-based skill nodes with prerequisites and costs.
- methods: `unlock_skill()`, `can_unlock()`, `get_available_skills()`, `reset_skills()`
- signals: `skill_unlocked`, `skill_point_spent`, `tree_reset`
- dependencies: ExperienceComponent

## racing & vehicle components

### vehiclephysicscomponent (3d)

- difficulty: 5/5 (expert)
- purpose: advanced vehicle physics with engine, suspension, and aerodynamics.
- implementation: RigidBody3D with custom physics calculations.
- methods: `apply_engine_force()`, `apply_brake_force()`, `update_suspension()`, `calculate_downforce()`
- signals: `engine_started`, `gear_changed`, `collision_occurred`, `tire_slip`
- dependencies: VelocityComponent

### tirecomponent (3d)

- difficulty: 4/5 (advanced)
- purpose: individual tire physics with wear, grip, and temperature.
- implementation: per-wheel physics with surface material interaction.
- methods: `calculate_grip()`, `apply_wear()`, `get_temperature()`, `set_tire_pressure()`
- signals: `tire_worn`, `grip_lost`, `punctured`
- dependencies: VehiclePhysicsComponent

### laptimercomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: race timing with sector splits and lap records.
- implementation: checkpoint-based timing system with persistent records.
- methods: `start_lap()`, `finish_lap()`, `add_checkpoint()`, `get_best_time()`, `reset_timer()`
- signals: `lap_started`, `lap_finished`, `checkpoint_passed`, `new_record`
- dependencies: none

### trackcomponent (3d)

- difficulty: 4/5 (advanced)
- purpose: racing track with splines, sectors, and surface materials.
- implementation: Path3D-based track with surface grip modifiers.
- methods: `get_track_position()`, `get_surface_grip()`, `get_track_width()`, `is_off_track()`
- signals: `off_track`, `surface_changed`, `sector_entered`
- dependencies: none

### pitstopcomponent (3d)

- difficulty: 3/5 (intermediate)
- purpose: manages pit stop mechanics for tire changes and repairs.
- implementation: Area3D trigger with repair/refuel timers.
- methods: `enter_pit()`, `start_service()`, `complete_service()`, `calculate_service_time()`
- signals: `pit_entered`, `service_started`, `service_completed`, `pit_exited`
- dependencies: VehiclePhysicsComponent, TireComponent

## advanced visual & environment components

### weathercomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: dynamic weather system with rain, snow, fog, and wind.
- implementation: shader-based effects with gameplay impact on visibility/physics.
- methods: `set_weather_type()`, `transition_weather()`, `get_visibility()`, `get_wind_force()`
- signals: `weather_changed`, `storm_started`, `visibility_changed`
- dependencies: ParticleComponent

### daynightcomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: time-based lighting and environment changes.
- implementation: DirectionalLight3D rotation with color temperature shifts.
- methods: `set_time()`, `advance_time()`, `get_time_of_day()`, `set_time_scale()`
- signals: `time_changed`, `dawn`, `dusk`, `midnight`, `noon`
- dependencies: none

### terraincomponent (3d)

- difficulty: 4/5 (advanced)
- purpose: heightmap-based terrain with multiple texture layers.
- implementation: MeshInstance3D with custom terrain shader and collision.
- methods: `generate_terrain()`, `get_height_at()`, `paint_texture()`, `add_detail_mesh()`
- signals: `terrain_generated`, `texture_painted`, `height_modified`
- dependencies: NoiseComponent

### biomecomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: procedural biome generation with vegetation and climate rules.
- implementation: rule-based system for spawning appropriate flora/fauna.
- methods: `generate_biome()`, `spawn_vegetation()`, `set_climate_rules()`, `get_biome_type()`
- signals: `biome_generated`, `vegetation_spawned`, `climate_changed`
- dependencies: TerrainComponent, NoiseComponent

### lodcomponent (3d)

- difficulty: 4/5 (advanced)
- purpose: level-of-detail management for performance optimization.
- implementation: distance-based mesh switching with automatic lod generation.
- methods: `set_lod_distances()`, `force_lod_level()`, `generate_lods()`, `update_lod()`
- signals: `lod_changed`, `lod_generated`
- dependencies: none
- performance note: ✅ this component improves performance. use 3-4 lod levels with distances like [50, 100, 200] meters. add hysteresis (10-20% overlap) to prevent lod flickering. disable expensive components (particles, ai) at highest lod levels. can reduce draw calls by 50-70% in large scenes.

### cullingcomponent (3d)

- difficulty: 4/5 (advanced)
- purpose: frustum and occlusion culling for rendering optimization.
- implementation: camera-based visibility testing with occlusion queries.
- methods: `is_visible()`, `set_culling_mask()`, `force_visible()`, `update_bounds()`
- signals: `visibility_changed`, `culled`, `unculled`
- dependencies: Camera3D
- performance note: ✅ this component improves performance. frustum culling is automatic in godot, but this component adds occlusion culling for objects hidden behind others. can reduce draw calls by 30-50% in dense scenes. update culling checks every 2-3 frames, not every frame. use larger bounding volumes for distant objects to reduce culling overhead.

## procedural generation components

### noisecomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: noise generation for procedural content.
- implementation: FastNoiseLite wrapper with multiple noise types and layers.
- methods: `generate_noise()`, `sample_noise()`, `add_noise_layer()`, `set_seed()`
- signals: `noise_generated`, `seed_changed`
- dependencies: none

### chunkcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: world streaming with chunk loading/unloading.
- implementation: grid-based world division with async chunk generation.
- methods: `load_chunk()`, `unload_chunk()`, `is_chunk_loaded()`, `get_chunk_at()`
- signals: `chunk_loaded`, `chunk_unloaded`, `chunk_generated`
- dependencies: NoiseComponent
- performance note: ✅ this component improves performance. generate chunks in background threads to avoid stuttering. use chunk sizes of 16x16 or 32x32 for optimal performance. keep 3x3 or 5x5 grid of chunks loaded around player. unload chunks outside view distance. can enable infinite worlds with constant memory usage.

### dungeongeneratorcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: procedural dungeon/level generation with rooms and corridors.
- implementation: graph-based room placement with pathfinding connections.
- methods: `generate_dungeon()`, `add_room_type()`, `connect_rooms()`, `place_objects()`
- signals: `dungeon_generated`, `room_created`, `corridor_created`
- dependencies: NoiseComponent

### wavecollapsecomponent (2d/3d)

- difficulty: 5/5 (expert)
- purpose: wave function collapse algorithm for tile-based generation.
- implementation: constraint-based tile placement with adjacency rules.
- methods: `set_tileset()`, `add_constraint()`, `generate_pattern()`, `collapse_wave()`
- signals: `pattern_generated`, `constraint_violated`, `generation_complete`
- dependencies: none

### lsystemcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: l-system based procedural generation for plants/structures.
- implementation: grammar-based recursive generation with turtle graphics.
- methods: `set_grammar()`, `generate_structure()`, `set_iterations()`, `render_system()`
- signals: `structure_generated`, `iteration_complete`
- dependencies: none

## performance & optimization components

### batchingcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: batches similar objects for rendering optimization.
- implementation: groups objects with same material/mesh for draw call reduction.
- methods: `add_to_batch()`, `remove_from_batch()`, `update_batch()`, `get_batch_count()`
- signals: `batch_created`, `batch_updated`, `batch_destroyed`
- dependencies: none
- performance note: ✅ this component improves performance. can reduce draw calls from thousands to dozens for similar objects (tiles, particles, foliage). most effective for static or rarely-moving objects. dynamic batching has overhead - only batch objects that share materials/meshes. godot 4.x has automatic batching for 2d; use this for additional 3d optimization.

### streamingcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: manages asset streaming and memory optimization.
- implementation: distance-based asset loading/unloading with memory pools.
- methods: `stream_asset()`, `unstream_asset()`, `set_streaming_distance()`, `get_memory_usage()`
- signals: `asset_streamed`, `asset_unstreamed`, `memory_threshold_reached`
- dependencies: none
- performance note: ✅ this component improves performance and reduces memory usage. essential for large open worlds. stream assets in background threads to avoid frame drops. keep 2-3 "rings" of assets loaded (immediate, near, far). unload assets 1.5x beyond streaming distance to prevent thrashing. can reduce memory usage by 60-80% in large games.

### cachecomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: caches frequently accessed data and resources.
- implementation: lru cache with configurable size limits and expiration.
- methods: `cache_data()`, `get_cached()`, `clear_cache()`, `set_cache_size()`
- signals: `cache_hit`, `cache_miss`, `cache_cleared`, `cache_full`
- dependencies: none

### profilercomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: performance profiling and bottleneck identification.
- implementation: frame timing analysis with detailed performance metrics.
- methods: `start_profiling()`, `stop_profiling()`, `get_metrics()`, `export_profile()`
- signals: `profiling_started`, `profiling_stopped`, `bottleneck_detected`
- dependencies: none

## ecs & data-driven components

### entitycomponent (2d/3d)

- difficulty: 5/5 (expert)
- purpose: pure ecs entity with component composition.
- implementation: entity id system with component registry and composition.
- methods: `add_component()`, `remove_component()`, `get_component()`, `has_component()`
- signals: `component_added`, `component_removed`, `entity_destroyed`
- dependencies: none

### transformdatacomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: pure data container for position, rotation, scale.
- implementation: struct-like data component with no behavior.
- methods: `set_position()`, `set_rotation()`, `set_scale()`, `get_transform_matrix()`
- signals: `transform_changed`
- dependencies: none

### renderdatacomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: pure data container for rendering information.
- implementation: mesh, material, and rendering state data.
- methods: `set_mesh()`, `set_material()`, `set_visibility()`, `get_render_data()`
- signals: `render_data_changed`
- dependencies: none

### physicsdatacomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: pure data container for physics properties.
- implementation: mass, velocity, forces, and collision data.
- methods: `set_mass()`, `set_velocity()`, `add_force()`, `get_physics_data()`
- signals: `physics_data_changed`
- dependencies: none

### systemmanagercomponent (2d/3d)

- difficulty: 5/5 (expert)
- purpose: manages ecs systems and component processing.
- implementation: system registry with update order and dependency management.
- methods: `register_system()`, `unregister_system()`, `update_systems()`, `get_system()`
- signals: `system_registered`, `system_unregistered`, `systems_updated`
- dependencies: EntityComponent

## multiplayer & networking components

### networksynccomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: synchronizes component data across network using MultiplayerSynchronizer.
- implementation: godot 4.x MultiplayerSynchronizer with custom replication config.
- methods: `set_sync_properties()`, `force_sync()`, `set_sync_interval()`, `is_syncing()`
- signals: `sync_started`, `sync_stopped`, `data_received`, `sync_error`
- dependencies: MultiplayerSynchronizer

### authoritycomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: manages network authority and ownership for multiplayer objects.
- implementation: authority-based networking with ownership transfer.
- methods: `set_authority()`, `request_authority()`, `has_authority()`, `transfer_authority()`
- signals: `authority_gained`, `authority_lost`, `authority_requested`, `authority_denied`
- dependencies: NetworkSyncComponent

### networkspawnercomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: handles network object spawning using MultiplayerSpawner.
- implementation: godot 4.x MultiplayerSpawner with scene management.
- methods: `spawn_object()`, `despawn_object()`, `set_spawn_scene()`, `get_spawned_objects()`
- signals: `object_spawned`, `object_despawned`, `spawn_failed`
- dependencies: MultiplayerSpawner

### replicationcomponent (2d/3d)

- difficulty: 5/5 (expert)
- purpose: custom data replication with compression and delta encoding.
- implementation: efficient state replication with customizable update rates.
- methods: `replicate_data()`, `set_replication_rate()`, `compress_data()`, `apply_delta()`
- signals: `data_replicated`, `replication_error`, `delta_applied`
- dependencies: NetworkSyncComponent

### lagcompensationcomponent (2d/3d)

- difficulty: 5/5 (expert)
- purpose: client-side prediction and server reconciliation for smooth gameplay.
- implementation: input buffering with rollback and prediction systems.
- methods: `predict_movement()`, `reconcile_state()`, `buffer_input()`, `rollback_to()`
- signals: `prediction_made`, `state_reconciled`, `rollback_occurred`
- dependencies: NetworkSyncComponent

### voicechatcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: proximity-based voice chat with 3d audio positioning.
- implementation: AudioStreamPlayer3D with network audio streaming.
- methods: `start_recording()`, `stop_recording()`, `set_voice_range()`, `mute_player()`
- signals: `recording_started`, `recording_stopped`, `voice_received`, `player_muted`
- dependencies: AudioStreamPlayer3D

## production & system components

### settingscomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: manages game settings (graphics, audio, controls, accessibility).
- implementation: saves/loads settings to user config, applies changes.
- methods: `load_settings()`, `save_settings()`, `apply_setting()`, `get_setting()`
- signals: `setting_changed`
- dependencies: none

### localizationcomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: handles multi-language support for text and assets.
- implementation: loads translation files, switches active language.
- methods: `set_language()`, `get_string()`, `get_localized_asset()`
- signals: `language_changed`
- dependencies: none

### achievementcomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: integrates with steam achievements or in-game achievement system.
- implementation: tracks progress, unlocks achievements.
- methods: `unlock_achievement()`, `increment_stat()`, `get_achievement_status()`
- signals: `achievement_unlocked`
- dependencies: steamworks sdk (optional)

### cloudsavecomponent (2d/3d)

- difficulty: 4/5 (advanced)
- purpose: synchronizes save data with steam cloud or custom backend.
- implementation: uploads/downloads save files, handles conflicts.
- methods: `upload_save()`, `download_save()`, `delete_cloud_save()`
- signals: `save_uploaded`, `save_downloaded`, `save_conflict`
- dependencies: steamworks sdk (optional)

### analyticscomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: tracks game events, player behavior, and crash reports.
- implementation: sends data to analytics service (e.g., google analytics, custom backend).
- methods: `track_event()`, `track_screen()`, `log_error()`
- signals: none
- dependencies: analytics sdk (optional)

### inputremapcomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: allows players to rebind input actions.
- implementation: modifies godot's input map, saves/loads bindings.
- methods: `remap_action()`, `reset_to_default()`, `get_current_binding()`
- signals: `input_remapped`
- dependencies: none

### audiomixercomponent (2d/3d)

- difficulty: 3/5 (intermediate)
- purpose: manages audio buses, volume, and effects.
- implementation: controls godot's audio server, applies mixing rules.
- methods: `set_bus_volume()`, `mute_bus()`, `add_effect_to_bus()`
- signals: `volume_changed`, `bus_muted`
- dependencies: none

### screenshotcomponent (2d/3d)

- difficulty: 2/5 (easy)
- purpose: captures screenshots for marketing or in-game features.
- implementation: saves viewport texture to file.
- methods: `take_screenshot()`, `set_resolution()`, `set_format()`
- signals: `screenshot_taken`
- dependencies: viewport
