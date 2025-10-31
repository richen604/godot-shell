# AI Entity Integration

Complete example integrating AI behavior components into an intelligent enemy entity.

## Overview

Wire together detection, pathfinding, state management, and behavior components for AI-controlled entities.

## Components Used

**AI**: DetectionComponent, PathfindComponent, FollowComponent, PatrolComponent, StateMachineComponent
**Core**: HealthComponent, VelocityComponent, MovementComponent, TimerComponent
**Combat**: HurtBoxComponent, HitBoxComponent, WeaponComponent

## Complete AI Entity

```gdscript
# AIEntity.gd
extends CharacterBody2D

@onready var health = $HealthComponent
@onready var velocity_comp = $VelocityComponent
@onready var movement = $MovementComponent
@onready var detection = $DetectionComponent
@onready var pathfind = $PathfindComponent
@onready var follow = $FollowComponent
@onready var patrol = $PatrolComponent
@onready var state_machine = $StateMachineComponent
@onready var hurt_box = $HurtBoxComponent
@onready var weapon = $WeaponComponent
@onready var timer = $TimerComponent
@onready var audio = $AudioComponent

var current_target: Node2D = null
var last_known_position: Vector2 = Vector2.ZERO

func _ready():
    _setup_core_systems()
    _setup_ai_behavior()
    _setup_combat()
    _setup_state_machine()

func _setup_core_systems():
    movement.set_velocity_component(velocity_comp)
    hurt_box.set_health_component(health)
    health.health_depleted.connect(_on_death)

func _setup_ai_behavior():
    pathfind.set_velocity_component(velocity_comp)
    follow.set_velocity_component(velocity_comp)
    detection.target_detected.connect(_on_target_detected)
    detection.target_lost.connect(_on_target_lost)
    pathfind.target_reached.connect(_on_destination_reached)
    pathfind.path_blocked.connect(_on_path_blocked)

func _setup_combat():
    timer.start_timer("check_attack_range", 0.2, true)
    timer.timeout.connect(_on_timer_timeout)

func _setup_state_machine():
    state_machine.add_state("idle", _idle_state)
    state_machine.add_state("patrol", _patrol_state)
    state_machine.add_state("chase", _chase_state)
    state_machine.add_state("attack", _attack_state)
    state_machine.add_state("investigate", _investigate_state)
    state_machine.add_state("flee", _flee_state)
    state_machine.change_state("patrol")

# AI States
func _idle_state():
    velocity_comp.set_velocity(Vector2.ZERO)
    if not timer.has_timer("idle_timeout"):
        timer.start_timer("idle_timeout", 2.0, false)

func _patrol_state():
    if not patrol.is_patrolling():
        patrol.start_patrol()
    patrol.update_patrol()

func _chase_state():
    if current_target and is_instance_valid(current_target):
        pathfind.set_target(current_target.global_position)
        pathfind.update_pathfinding()
        
        var distance = global_position.distance_to(current_target.global_position)
        if distance < weapon.get_attack_range():
            state_machine.change_state("attack")
    else:
        state_machine.change_state("investigate")

func _attack_state():
    if current_target and is_instance_valid(current_target):
        var distance = global_position.distance_to(current_target.global_position)
        
        if distance > weapon.get_attack_range():
            state_machine.change_state("chase")
            return
        
        velocity_comp.set_velocity(Vector2.ZERO)
        var direction = (current_target.global_position - global_position).normalized()
        rotation = direction.angle()
        
        if weapon.can_fire():
            weapon.fire(direction)
    else:
        state_machine.change_state("investigate")

func _investigate_state():
    pathfind.set_target(last_known_position)
    pathfind.update_pathfinding()
    
    if global_position.distance_to(last_known_position) < 10.0:
        timer.start_timer("investigation_timeout", 3.0, false)

func _flee_state():
    if current_target and is_instance_valid(current_target):
        var flee_direction = (global_position - current_target.global_position).normalized()
        velocity_comp.set_velocity(flee_direction * velocity_comp.max_speed)
    
    if health.current_health > health.max_health * 0.5:
        state_machine.change_state("patrol")

# Signal Handlers
func _on_target_detected(target: Node2D):
    current_target = target
    last_known_position = target.global_position
    audio.play_sound("alert")
    
    if health.current_health < health.max_health * 0.3:
        state_machine.change_state("flee")
    else:
        state_machine.change_state("chase")

func _on_target_lost():
    state_machine.change_state("investigate")

func _on_destination_reached():
    if state_machine.get_current_state() == "investigate":
        state_machine.change_state("patrol")

func _on_path_blocked():
    pathfind.recalculate_path()

func _on_timer_timeout(timer_name: String):
    match timer_name:
        "idle_timeout":
            state_machine.change_state("patrol")
        "investigation_timeout":
            state_machine.change_state("patrol")
        "check_attack_range":
            _check_attack_range()

func _check_attack_range():
    if state_machine.get_current_state() == "chase":
        if current_target and is_instance_valid(current_target):
            var distance = global_position.distance_to(current_target.global_position)
            if distance < weapon.get_attack_range():
                state_machine.change_state("attack")

func _on_death():
    state_machine.set_enabled(false)
    detection.set_enabled(false)
    pathfind.set_enabled(false)
    audio.play_sound("death")
    await get_tree().create_timer(1.0).timeout
    queue_free()
```

## Scene Tree Structure

```
AIEntity (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── HealthComponent
├── VelocityComponent
├── MovementComponent
├── DetectionComponent (Area2D)
│   └── CollisionShape2D
├── PathfindComponent
├── FollowComponent
├── PatrolComponent
├── StateMachineComponent
├── HurtBoxComponent (Area2D)
│   └── CollisionShape2D
├── WeaponComponent
├── TimerComponent
└── AudioComponent
```

## Step-by-Step Integration

### Step 1: Basic Movement

```gdscript
@onready var velocity_comp = $VelocityComponent
@onready var movement = $MovementComponent

func _ready():
    movement.set_velocity_component(velocity_comp)
```

### Step 2: Add Patrol

```gdscript
@onready var patrol = $PatrolComponent

func _ready():
    movement.set_velocity_component(velocity_comp)
    patrol.start_patrol()

func _process(delta):
    patrol.update_patrol()
```

### Step 3: Add Detection

```gdscript
@onready var detection = $DetectionComponent
var current_target: Node2D = null

func _ready():
    detection.target_detected.connect(_on_target_detected)
    patrol.start_patrol()

func _on_target_detected(target: Node2D):
    current_target = target
    patrol.stop_patrol()
```

### Step 4: Add Pathfinding

```gdscript
@onready var pathfind = $PathfindComponent

func _ready():
    pathfind.set_velocity_component(velocity_comp)

func _process(delta):
    if current_target:
        pathfind.set_target(current_target.global_position)
        pathfind.update_pathfinding()
    else:
        patrol.update_patrol()
```

### Step 5: Add State Machine

```gdscript
@onready var state_machine = $StateMachineComponent

func _ready():
    state_machine.add_state("patrol", _patrol_state)
    state_machine.add_state("chase", _chase_state)
    state_machine.change_state("patrol")

func _patrol_state():
    patrol.update_patrol()

func _chase_state():
    if current_target:
        pathfind.set_target(current_target.global_position)
        pathfind.update_pathfinding()
```

## Common AI Patterns

### Aggressive AI

```gdscript
func _on_target_detected(target: Node2D):
    current_target = target
    state_machine.change_state("chase")
```

### Defensive AI

```gdscript
func _on_target_detected(target: Node2D):
    current_target = target
    if health.current_health < health.max_health * 0.3:
        state_machine.change_state("flee")
    else:
        state_machine.change_state("chase")
```

### Cautious AI

```gdscript
func _attack_state():
    if current_target:
        var distance = global_position.distance_to(current_target.global_position)
        var ideal_distance = weapon.get_attack_range() * 0.8
        
        if distance < ideal_distance:
            var flee_direction = (global_position - current_target.global_position).normalized()
            velocity_comp.set_velocity(flee_direction * velocity_comp.max_speed * 0.5)
        elif distance > weapon.get_attack_range():
            state_machine.change_state("chase")
        else:
            velocity_comp.set_velocity(Vector2.ZERO)
            weapon.fire((current_target.global_position - global_position).normalized())
```

### Group Coordination

```gdscript
func _on_target_detected(target: Node2D):
    current_target = target
    
    var allies = get_tree().get_nodes_in_group("enemies")
    for ally in allies:
        if ally != self and global_position.distance_to(ally.global_position) < 200:
            ally.alert_to_target(target)
    
    state_machine.change_state("chase")

func alert_to_target(target: Node2D):
    if not current_target:
        current_target = target
        last_known_position = target.global_position
        state_machine.change_state("investigate")
```

## Testing Checklist

- [ ] AI patrols when no target
- [ ] AI detects player in range
- [ ] AI chases using pathfinding
- [ ] AI attacks in range
- [ ] AI investigates last position
- [ ] AI returns to patrol
- [ ] AI flees when low health
- [ ] State transitions smooth
- [ ] Pathfinding avoids obstacles
- [ ] AI responds to damage

## Performance Tips

1. **Update Frequency**: Reduce AI update rate for distant enemies
2. **Detection Range**: Use smaller ranges
3. **Pathfinding**: Cache paths, recalculate only when needed
4. **State Machine**: Keep logic simple
5. **Group Limits**: Limit active AI count

## Common Issues

**AI stuck on obstacles**:

- Increase pathfinding margin
- Add obstacle avoidance
- Implement unstuck detection

**AI doesn't detect player**:

- Check detection layer masks
- Verify collision shapes
- Ensure target in detection group

**AI jitters**:

- Reduce pathfinding update frequency
- Add movement smoothing
- Check velocity calculations

**State machine doesn't transition**:

- Verify state conditions
- Check signal connections
- Add debug logging

## Next Steps

- [Combat System](combat-system.md) for combat AI
- [RPG Character](rpg-character.md) for stats
- [Performance Guide](../advanced/performance.md) for optimization
