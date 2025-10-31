# Multiplayer Entity Integration

Complete example integrating network components for multiplayer gameplay.

## Overview

Wire together network synchronization, authority management, and replication components for multiplayer-enabled entities.

## Components Used

**Network**: NetworkSyncComponent, AuthorityComponent, ReplicationComponent, LagCompensationComponent
**Core**: HealthComponent, VelocityComponent, MovementComponent, WeaponComponent
**Utility**: TimerComponent, AudioComponent

## Complete Multiplayer Entity

```gdscript
# NetworkEntity.gd
extends CharacterBody2D

@onready var health = $HealthComponent
@onready var velocity_comp = $VelocityComponent
@onready var movement = $MovementComponent
@onready var weapon = $WeaponComponent
@onready var network_sync = $NetworkSyncComponent
@onready var authority = $AuthorityComponent
@onready var replication = $ReplicationComponent
@onready var lag_compensation = $LagCompensationComponent
@onready var timer = $TimerComponent
@onready var audio = $AudioComponent

var is_local_player: bool = false

func _ready():
    _setup_core_systems()
    _setup_network()
    _setup_authority()

func _setup_core_systems():
    movement.set_velocity_component(velocity_comp)
    health.health_changed.connect(_on_health_changed)
    health.health_depleted.connect(_on_death)

func _setup_network():
    network_sync.set_sync_properties(["position", "velocity", "rotation", "health"])
    network_sync.set_sync_rate(20)
    replication.state_received.connect(_on_state_received)
    replication.input_received.connect(_on_input_received)

func _setup_authority():
    var peer_id = get_multiplayer_authority()
    authority.set_authority(peer_id)
    is_local_player = peer_id == multiplayer.get_unique_id()
    authority.authority_gained.connect(_on_authority_gained)
    authority.authority_lost.connect(_on_authority_lost)
    
    if is_local_player:
        lag_compensation.enable_prediction(true)
        lag_compensation.correction_applied.connect(_on_correction_applied)

# Input Handling
func _physics_process(delta):
    if not is_local_player:
        _apply_replicated_state()
        return
    
    _handle_input(delta)
    if not multiplayer.is_server():
        _send_input_to_server()

func _handle_input(delta):
    var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    
    if input_vector != Vector2.ZERO:
        velocity_comp.accelerate(input_vector)
    else:
        velocity_comp.apply_friction()
    
    movement.update_movement(delta)
    
    if Input.is_action_just_pressed("shoot"):
        _fire_weapon()

func _send_input_to_server():
    var input_state = {
        "timestamp": Time.get_ticks_msec(),
        "position": global_position,
        "velocity": velocity_comp.get_velocity(),
        "input_vector": Input.get_vector("move_left", "move_right", "move_up", "move_down"),
        "shoot": Input.is_action_just_pressed("shoot")
    }
    replication.send_input(input_state)

# Network Replication
func _apply_replicated_state():
    if replication.has_pending_state():
        var state = replication.get_latest_state()
        global_position = global_position.lerp(state.position, 0.3)
        velocity_comp.set_velocity(state.velocity.lerp(velocity_comp.get_velocity(), 0.3))
        rotation = lerp_angle(rotation, state.rotation, 0.3)
        if state.has("health"):
            health.set_current_health(state.health)

func _on_state_received(state: Dictionary):
    if is_local_player and lag_compensation.is_prediction_enabled():
        var position_error = global_position.distance_to(state.position)
        if position_error > 50.0:
            lag_compensation.apply_correction(state)
            global_position = state.position
            velocity_comp.set_velocity(state.velocity)

func _on_input_received(input_state: Dictionary):
    if not multiplayer.is_server():
        return
    
    if not _validate_input(input_state):
        return
    
    var input_vector = input_state.input_vector
    if input_vector != Vector2.ZERO:
        velocity_comp.accelerate(input_vector)
    else:
        velocity_comp.apply_friction()
    
    if input_state.shoot:
        _fire_weapon()

func _validate_input(input_state: Dictionary) -> bool:
    var current_time = Time.get_ticks_msec()
    if current_time - input_state.timestamp > 1000:
        return false
    
    if global_position.distance_to(input_state.position) > 500.0:
        return false
    
    if input_state.velocity.length() > velocity_comp.max_speed * 1.1:
        return false
    
    return true

# Lag Compensation
func _on_correction_applied(correction: Dictionary):
    if correction.error_magnitude > 100.0:
        audio.play_sound("desync")

# Authority Management
func _on_authority_gained():
    is_local_player = true
    set_process_input(true)
    set_physics_process(true)
    movement.set_enabled(true)
    lag_compensation.enable_prediction(true)

func _on_authority_lost():
    is_local_player = false
    set_process_input(false)
    lag_compensation.enable_prediction(false)

# Networked Combat
@rpc("any_peer", "call_local")
func _fire_weapon():
    if not weapon.can_fire():
        return
    
    var direction = (get_global_mouse_position() - global_position).normalized()
    weapon.fire(direction)
    audio.play_sound("weapon_fire")
    
    if multiplayer.is_server():
        _check_weapon_hits(direction)

@rpc("authority", "call_local")
func _take_damage(damage: float, attacker_id: int):
    if not multiplayer.is_server():
        return
    
    health.take_damage(damage)
    rpc("_on_damage_taken", damage, attacker_id)

@rpc("authority", "call_local")
func _on_damage_taken(damage: float, attacker_id: int):
    audio.play_sound("hurt")
    var damage_text = preload("res://ui/damage_number.tscn").instantiate()
    damage_text.set_damage(damage)
    add_child(damage_text)

func _check_weapon_hits(direction: Vector2):
    var hit_entities = weapon.get_hit_entities(direction)
    for entity in hit_entities:
        if entity.has_method("_take_damage"):
            entity._take_damage(weapon.get_damage(), multiplayer.get_unique_id())

# Network Events
func _on_health_changed(old_health: float, new_health: float):
    if multiplayer.is_server():
        network_sync.sync_property("health", new_health)

@rpc("authority", "call_local")
func _on_death():
    movement.set_enabled(false)
    weapon.set_enabled(false)
    audio.play_sound("death")
    
    if multiplayer.is_server():
        timer.start_timer("respawn", 5.0, false)
        timer.timeout.connect(_on_respawn_timer)

func _on_respawn_timer(timer_name: String):
    if timer_name == "respawn":
        health.heal(health.max_health)
        global_position = _get_spawn_point()
        movement.set_enabled(true)
        weapon.set_enabled(true)
        rpc("_on_respawned")

@rpc("authority", "call_local")
func _on_respawned():
    audio.play_sound("respawn")

func _get_spawn_point() -> Vector2:
    var spawn_points = get_tree().get_nodes_in_group("spawn_points")
    return spawn_points.pick_random().global_position if not spawn_points.is_empty() else Vector2.ZERO
```

## Scene Tree Structure

```bash
NetworkEntity (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── HealthComponent
├── VelocityComponent
├── MovementComponent
├── WeaponComponent
├── NetworkSyncComponent
├── AuthorityComponent
├── ReplicationComponent
├── LagCompensationComponent
├── TimerComponent
└── AudioComponent
```

## Step-by-Step Integration

### Step 1: Basic Network Sync

```gdscript
@onready var network_sync = $NetworkSyncComponent

func _ready():
    network_sync.set_sync_properties(["position"])
    network_sync.set_sync_rate(20)
```

### Step 2: Add Authority

```gdscript
@onready var authority = $AuthorityComponent

func _ready():
    authority.set_authority(get_multiplayer_authority())
    authority.authority_gained.connect(_on_authority_gained)

func _on_authority_gained():
    set_process_input(true)
```

### Step 3: Add Input Replication

```gdscript
@onready var replication = $ReplicationComponent

func _physics_process(delta):
    if authority.has_authority():
        _handle_input(delta)
        _send_input_to_server()

func _send_input_to_server():
    replication.send_input({
        "position": global_position,
        "velocity": velocity_comp.get_velocity()
    })
```

### Step 4: Add Lag Compensation

```gdscript
@onready var lag_compensation = $LagCompensationComponent

func _ready():
    if authority.has_authority():
        lag_compensation.enable_prediction(true)
        lag_compensation.correction_applied.connect(_on_correction)

func _on_correction(correction: Dictionary):
    global_position = correction.position
```

## Common Patterns

### Server-Authoritative Combat

```gdscript
@rpc("any_peer")
func request_attack(target_id: int):
    if not multiplayer.is_server():
        return
    
    if _can_attack(target_id):
        var target = get_node_or_null(str(target_id))
        if target:
            target.take_damage(weapon.get_damage())
```

### Client-Side Prediction

```gdscript
func _handle_input(delta):
    velocity_comp.accelerate(input_vector)
    movement.update_movement(delta)
    
    lag_compensation.store_prediction({
        "position": global_position,
        "velocity": velocity_comp.get_velocity(),
        "timestamp": Time.get_ticks_msec()
    })
```

### Interpolation

```gdscript
func _apply_replicated_state():
    var state = replication.get_latest_state()
    global_position = global_position.lerp(state.position, 0.3)
    rotation = lerp_angle(rotation, state.rotation, 0.3)
```

## Testing Checklist

- [ ] Position syncs across network
- [ ] Authority transfers correctly
- [ ] Input replication works
- [ ] Lag compensation reduces rubber-banding
- [ ] Combat is server-authoritative
- [ ] Prediction errors corrected
- [ ] Interpolation is smooth
- [ ] Network bandwidth reasonable
- [ ] Cheating prevented

## Performance Tips

1. **Sync Rate**: Lower for distant players (10-15 Hz)
2. **Property Selection**: Only sync essentials
3. **Compression**: Compress position/rotation
4. **Interest Management**: Don't sync outside view
5. **Bandwidth**: Track and limit usage

## Common Issues

**Rubber-banding**:

- Increase interpolation factor
- Enable client prediction
- Reduce sync rate variance

**Desync**:

- Verify server authority
- Check timestamp validation
- Ensure deterministic physics

**High Bandwidth**:

- Reduce sync rate
- Compress data
- Implement interest management

**Input Lag**:

- Enable client prediction
- Reduce server processing time
- Optimize network code

## Next Steps

- [Combat System](combat-system.md) for networked combat
- [AI Entity](ai-entity.md) for AI opponents
- [Performance Guide](../advanced/performance.md) for optimization
