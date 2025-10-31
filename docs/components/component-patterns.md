# component design patterns

learn how to build and connect components effectively.

## table of contents

- [the lightweight glue pattern](#the-lightweight-glue-pattern)
- [component granularity](#component-granularity)
- [signal usage patterns](#signal-usage-patterns)
- [component communication](#component-communication)

---

## the lightweight glue pattern

the root entity script should be minimal "glue code" that wires components together.

### what belongs where

**✅ in components (reusable):**

- health management, movement calculations, pathfinding logic, combat mechanics, ai behaviors

**✅ in root script (entity-specific):**

- component wiring, signal connections, unique entity behavior, coordination between components

### example structure

```gdscript
# enemy.gd - root entity script (the "glue")
extends CharacterBody2D

# component references
@onready var health: HealthComponent = $HealthComponent
@onready var velocity_comp: VelocityComponent = $VelocityComponent
@onready var pathfind: PathfindComponent = $PathfindComponent

# exported variables (designer-friendly)
@export_group("behavior")
@export var aggro_range: float = 300.0
@export var attack_range: float = 50.0

# internal state
var target: Node2D = null
var is_dead: bool = false

# initialization
func _ready() -> void:
    # 1. connect components to each other
    pathfind.set_velocity_component(velocity_comp)
    
    # 2. wire up signals
    health.health_changed.connect(_on_health_changed)
    health.health_depleted.connect(_on_death)

# game loop
func _physics_process(delta: float) -> void:
    if is_dead:
        return
    
    if target and global_position.distance_to(target.global_position) <= attack_range:
        _attack_target()
    elif target:
        pathfind.move_toward_target(target.global_position, delta)
    
    velocity = velocity_comp.get_velocity()
    move_and_slide()

# signal handlers
func _on_health_changed(old_health: int, new_health: int) -> void:
    if new_health < old_health:
        _flash_damage()

func _on_death() -> void:
    is_dead = true
    queue_free()
```

### key principles

1. component references: use `@onready` for initialization
2. component wiring: connect components in `_ready()`
3. signal communication: wire signals for loose coupling
4. exported variables: make behavior tweakable
5. minimal logic: delegate to components
6. coordination: root script coordinates components

---

## component granularity

deciding component size is crucial for maintainability.

### the decision framework

ask these questions in order:

1. is this reusable across multiple entities? yes → strong candidate for component
2. does this have clear inputs/outputs? yes → good component boundary
3. can this be tested in isolation? yes → component will be easier to maintain
4. does this have configurable parameters? yes → component with @export variables
5. is this more than ~50 lines of code? yes → probably deserves its own component

### good granularity example

```gdscript
# ✅ perfect granularity - healthcomponent
class_name HealthComponent
extends Node

signal health_changed(old_health: int, new_health: int)
signal health_depleted

@export var max_health: int = 100
@export var invulnerable: bool = false
var current_health: int

func take_damage(amount: int) -> void:
    if invulnerable:
        return
    var old = current_health
    current_health = max(0, current_health - amount)
    health_changed.emit(old, current_health)
    if current_health == 0:
        health_depleted.emit()
```

**why this works:**

- ✅ reusable across all entities with health
- ✅ clear interface: `take_damage()`, `heal()`, signals
- ✅ testable in isolation
- ✅ configurable with exports
- ✅ right size: ~50-100 lines

### practical guidelines

**create separate component when:**

- reusable across entities (health, movement, inventory)
- complex algorithm (pathfinding, state machines)
- designers need to tweak it (jump height, attack patterns)

**keep in root script when:**

- entity-specific logic (unique boss mechanics)
- simple coordination (wiring components)
- trivial helpers (one-off calculations)

### red flags

🚩 too small if: less than 20 lines, only one or two simple methods, exists just to "follow the pattern"

🚩 too large if: more than 200 lines, multiple unrelated responsibilities, name contains "and"

🚩 wrong abstraction if: components tightly coupled, lots of cross-component method calls, difficult to explain in one sentence

### the "explain test"

if you can't explain what a component does in one sentence, it's doing too much:

- ✅ "manages entity health and damage"
- ✅ "handles 2d pathfinding to a target"
- ❌ "manages health and also does movement and sometimes attacks"

---

## signal usage patterns

signals are the primary mechanism for component communication.

### core principles

1. components emit signals, root scripts connect them
2. signals describe what happened, not what should happen
3. use signals for one-to-many communication
4. use direct calls for one-to-one dependencies

### pattern 1: component → root script

```gdscript
# healthcomponent.gd
signal health_changed(old_health: int, new_health: int)
signal health_depleted
signal damage_taken(amount: int)

func take_damage(amount: int) -> void:
    var old_health = current_health
    current_health = max(0, current_health - amount)
    damage_taken.emit(amount)
    health_changed.emit(old_health, current_health)
    if current_health == 0:
        health_depleted.emit()
```

```gdscript
# enemy.gd - root script connects and responds
func _ready():
    health.damage_taken.connect(_on_damage_taken)
    health.health_depleted.connect(_on_death)

func _on_damage_taken(amount: int) -> void:
    _play_hurt_animation()
    _spawn_damage_number(amount)
```

### pattern 2: component → component (indirect)

```gdscript
# hurtboxcomponent.gd
signal hit_received(damage: int, hit_position: Vector2)
var health_component: HealthComponent

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("projectile"):
        var damage = area.get_damage()
        # direct call for core functionality
        if health_component:
            health_component.take_damage(damage)
        # signal for optional features
        hit_received.emit(damage, area.global_position)
```

**when to use:**

- direct call: core functionality, required dependency
- signal: optional features, multiple listeners

### pattern 3: signal naming conventions

```gdscript
# ✅ good: past tense for events that happened
signal health_changed(old: int, new: int)
signal damage_taken(amount: int)
signal item_collected(item: Item)

# ✅ good: present tense for state changes
signal health_depleted
signal target_reached

# ❌ bad: imperative (sounds like command)
signal take_damage(amount: int)  # should be "damage_taken"
signal play_animation(name: String)  # should be "animation_started"
```

### pattern 4: avoiding signal spaghetti

```gdscript
# ❌ bad: signal spaghetti
func _ready():
    health.health_changed.connect(ui.update_health_bar)
    health.health_changed.connect(audio.play_hurt_sound)
    health.health_changed.connect(particles.spawn_blood)
    # ... 20 more connections

# ✅ good: single handler coordinates
func _ready():
    health.health_changed.connect(_on_health_changed)

func _on_health_changed(old: int, new: int) -> void:
    ui.update_health_bar(new, health.max_health)
    if new < old:
        audio.play_hurt_sound()
        particles.spawn_blood(global_position)
```

### best practices

✅ **do:**

- emit signals from components to notify events
- connect signals in root scripts
- use descriptive signal names (past tense)
- include relevant data in parameters
- use direct calls for required dependencies

❌ **don't:**

- make components call methods on other components
- use signals for simple getter/setter operations
- create circular signal dependencies
- emit signals in tight loops (performance)

---

## component communication

three main patterns for component communication.

### 1. signal-based (recommended)

**best for:** loose coupling, event-driven, one-to-many

```gdscript
health.health_changed.connect(health_bar.update_health)
weapon.fired.connect(audio.play_sound.bind("gunshot"))
detection.target_detected.connect(state_machine.change_state.bind("combat"))
```

**advantages:** components don't need direct references, easy to add/remove listeners, supports multiple listeners

**when to use:** default choice for most interactions

### 2. direct reference

**best for:** tight coupling, required dependencies, performance

```gdscript
movement.set_velocity_component(velocity_comp)
hurt_box.set_health_component(health)
pathfind.set_movement_component(movement)
```

**advantages:** faster than signals, explicit dependencies, type-safe method calls

**when to use:** when one component requires another to function

### 3. event bus pattern

**best for:** global events, cross-scene communication

```gdscript
# eventbus.gd - autoload singleton
extends Node

signal entity_died(entity)
signal item_collected(item, collector)
signal quest_completed(quest_id)

# usage:
# eventbus.entity_died.emit(self)
# eventbus.item_collected.connect(_on_item_collected)
```

**advantages:** complete decoupling, centralized event management, works across scenes

**warning:** overuse makes code hard to trace. use sparingly.

---

## component lifecycle

### initialization order

```gdscript
func _ready():
    # 1. initialize data components first
    stats.initialize_stats()
    health.set_max_health(stats.get_stat("constitution") * 10)
    
    # 2. set up component references
    movement.set_velocity_component(velocity_comp)
    hurt_box.set_health_component(health)
    
    # 3. connect signals
    health.health_depleted.connect(_on_death)
    
    # 4. start active components
    patrol.start_patrol()
```

### cleanup pattern

```gdscript
func _exit_tree():
    timer.stop_all_timers()
    if pool:
        pool.return_all_to_pool()
    if save:
        save.save_data()
```

---

## common mistakes to avoid

1. circular dependencies: don't have components reference each other in loops
2. missing null checks: always check if component references exist
3. signal leaks: disconnect signals in `_exit_tree()`
4. over-coupling: avoid too many direct component references
5. wrong initialization order: initialize data before behavior components

---

## next steps

- see examples: [integration examples](examples/integration/)
- learn refactoring: [refactoring guide](examples/refactoring.md)
- optimize: [performance guide](advanced/performance.md)
- test: [testing guide](advanced/testing.md)
