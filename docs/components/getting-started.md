# getting started with component-based godot

build your first playable game in 1-2 weeks using just 5-7 components.

## table of contents

- [minimal viable games](#minimal-viable-games)
- [quick start by skill level](#quick-start-by-skill-level)
- [development timeline](#development-timeline)
- [first component](#first-component)

---

## minimal viable games

### simple top-down shooter (2d)

components: healthcomponent, velocitycomponent, movementcomponent, hurtboxcomponent, hitboxcomponent, audiocomponent, weaponcomponent

week 1: player movement

```gdscript
# player.gd
extends CharacterBody2D

@onready var health: HealthComponent = $HealthComponent
@onready var velocity_comp: VelocityComponent = $VelocityComponent
@onready var movement: MovementComponent = $MovementComponent
@onready var audio: AudioComponent = $AudioComponent

func _ready():
    movement.set_velocity_component(velocity_comp)
    health.health_depleted.connect(_on_death)

func _physics_process(delta):
    var input_dir = Input.get_vector("left", "right", "up", "down")
    
    if input_dir.length() > 0:
        velocity_comp.accelerate_in_direction(input_dir, delta)
    else:
        velocity_comp.apply_friction(delta)
    
    velocity = velocity_comp.get_velocity()
    move_and_slide()

func _on_death():
    audio.play_sound("player_death")
    queue_free()
```

week 2: combat

```gdscript
# add to player.gd
@onready var weapon: WeaponComponent = $WeaponComponent
@onready var hurtbox: HurtBoxComponent = $HurtBoxComponent

func _ready():
    # ... previous code ...
    hurtbox.set_health_component(health)
    hurtbox.hurt.connect(_on_hurt)

func _physics_process(delta):
    # ... previous code ...
    if Input.is_action_pressed("shoot"):
        weapon.fire()

func _on_hurt(damage: int):
    audio.play_sound("player_hurt")
```

---

### simple platformer (2d)

components: healthcomponent, velocitycomponent, movementcomponent, jumpcomponent, hurtboxcomponent, audiocomponent

week 1: movement

```gdscript
# player.gd
extends CharacterBody2D

@onready var velocity_comp: VelocityComponent = $VelocityComponent
@onready var movement: MovementComponent = $MovementComponent
@onready var jump: JumpComponent = $JumpComponent

func _ready():
    movement.set_velocity_component(velocity_comp)
    jump.set_velocity_component(velocity_comp)

func _physics_process(delta):
    var input_x = Input.get_axis("left", "right")
    if input_x != 0:
        velocity_comp.accelerate_in_direction(Vector2(input_x, 0), delta)
    else:
        velocity_comp.apply_friction(delta)
    
    if Input.is_action_just_pressed("jump") and is_on_floor():
        jump.jump()
    
    if not is_on_floor():
        velocity_comp.apply_gravity(delta)
    
    velocity = velocity_comp.get_velocity()
    move_and_slide()
```

week 2: health

```gdscript
# add to player.gd
@onready var health: HealthComponent = $HealthComponent
@onready var hurtbox: HurtBoxComponent = $HurtBoxComponent
@onready var audio: AudioComponent = $AudioComponent

func _ready():
    # ... previous code ...
    hurtbox.set_health_component(health)
    health.health_depleted.connect(_on_death)

func _on_death():
    audio.play_sound("death")
    queue_free()
```

---

### simple rpg (2d)

components: healthcomponent, velocitycomponent, movementcomponent, interactablecomponent, statscomponent, inventorycomponent, audiocomponent

week 1: movement and interaction

```gdscript
# player.gd
extends CharacterBody2D

@onready var velocity_comp: VelocityComponent = $VelocityComponent
@onready var movement: MovementComponent = $MovementComponent
@onready var audio: AudioComponent = $AudioComponent

var nearby_interactable: Node = null

func _ready():
    movement.set_velocity_component(velocity_comp)

func _physics_process(delta):
    var input_dir = Input.get_vector("left", "right", "up", "down")
    
    if input_dir.length() > 0:
        velocity_comp.accelerate_in_direction(input_dir, delta)
    else:
        velocity_comp.apply_friction(delta)
    
    velocity = velocity_comp.get_velocity()
    move_and_slide()
    
    if Input.is_action_just_pressed("interact") and nearby_interactable:
        nearby_interactable.interact(self)
        audio.play_sound("interact")

func _on_interactable_area_entered(area):
    if area.has_method("interact"):
        nearby_interactable = area

func _on_interactable_area_exited(area):
    if area == nearby_interactable:
        nearby_interactable = null
```

week 2: rpg systems

```gdscript
# add to player.gd
@onready var health: HealthComponent = $HealthComponent
@onready var stats: StatsComponent = $StatsComponent
@onready var inventory: InventoryComponent = $InventoryComponent

func _ready():
    # ... previous code ...
    var constitution = stats.get_stat("constitution")
    health.set_max_health(100 + (constitution * 10))
    health.health_depleted.connect(_on_death)

func collect_item(item: Item):
    if inventory.add_item(item):
        audio.play_sound("item_collected")
        return true
    return false

func _on_death():
    audio.play_sound("death")
    # show game over screen
```

---

## quick start by skill level

### new to godot? (priority 1)

week 1-2: basics

- healthcomponent - simplest component
- timercomponent - utility patterns
- audiocomponent - resource management

week 3-4: movement

- velocitycomponent - physics foundation
- movementcomponent - apply movement

### intermediate? (priority 2)

week 1-2: combat

- hurtboxcomponent, hitboxcomponent, weaponcomponent

week 3-4: interaction & ai

- interactablecomponent, followcomponent, detectioncomponent

### advanced? (choose your path)

action games:

- priority 3: jumpcomponent, dashcomponent, pathfindcomponent
- priority 4: particlecomponent, screenshakecomponent, statemachinecomponent

rpg games:

- priority 5: statscomponent, experiencecomponent, inventorycomponent
- priority 6: questcomponent, dialoguecomponent, skilltreecomponent

performance:

- priority 5: cachecomponent, poolcomponent, batchingcomponent
- priority 6: lodcomponent, cullingcomponent, streamingcomponent

---

## development timeline

### solo developer (10-15 hours/week)

month 1: foundation (priority 1)

- week 1-2: healthcomponent, timercomponent, audiocomponent
- week 3-4: velocitycomponent, movementcomponent
- milestone: basic entity with health and movement

month 2: core gameplay (priority 2)

- week 1-2: hurtboxcomponent, hitboxcomponent, interactablecomponent
- week 3-4: followcomponent, weaponcomponent
- milestone: playable game with combat

month 3: enhanced features (priority 3)

- week 1-2: jumpcomponent, dashcomponent, healthbarcomponent, floatingtextcomponent
- week 3-4: blinkcomponent, lookatcomponent, pathfindcomponent, detectioncomponent
- milestone: polished gameplay with visual feedback

month 4: systems & polish (priority 4)

- week 1-2: particlecomponent, screenshakecomponent, patrolcomponent
- week 3-4: spawnercomponent, savecomponent, statemachinecomponent
- milestone: complete game systems

month 5: performance (priority 5)

- week 1-2: cachecomponent, profilercomponent, batchingcomponent, streamingcomponent
- week 3-4: statscomponent, experiencecomponent, inventorycomponent, poolcomponent
- milestone: steam-ready quality

month 6+: specialized (priority 6)

- rpg: questcomponent, dialoguecomponent, skilltreecomponent
- racing: vehiclephysicscomponent, tirecomponent, trackcomponent
- multiplayer: networksynccomponent, authoritycomponent, replicationcomponent
- milestone: genre-specific features

---

## first component

build healthcomponent step-by-step:

1. create the script:

```gdscript
# healthcomponent.gd
class_name HealthComponent
extends Node

signal health_changed(old_health: int, new_health: int)
signal health_depleted
signal damage_taken(amount: int)
signal healed(amount: int)

@export var max_health: int = 100
@export var invulnerable: bool = false

var current_health: int

func _ready():
    current_health = max_health

func take_damage(amount: int) -> void:
    if invulnerable or amount <= 0:
        return
    
    var old = current_health
    current_health = max(0, current_health - amount)
    
    damage_taken.emit(amount)
    health_changed.emit(old, current_health)
    
    if current_health == 0:
        health_depleted.emit()

func heal(amount: int) -> void:
    if amount <= 0:
        return
    
    var old = current_health
    current_health = min(max_health, current_health + amount)
    
    if current_health > old:
        healed.emit(amount)
        health_changed.emit(old, current_health)

func get_health_percent() -> float:
    return float(current_health) / float(max_health)
```

add to entity:

1. select entity (e.g., player)
2. add child node → node → rename to "healthcomponent"
3. attach healthcomponent.gd script
4. configure max_health in inspector
5. use in entity script:

```gdscript
# player.gd
extends CharacterBody2D

@onready var health: HealthComponent = $HealthComponent

func _ready():
    health.health_depleted.connect(_on_death)
    health.damage_taken.connect(_on_damage_taken)

func _on_death():
    print("player died!")
    queue_free()

func _on_damage_taken(amount: int):
    print("took ", amount, " damage!")
```

---

## next steps

1. build more components - [component reference](components.md)
2. learn patterns - [component patterns](component-patterns.md)
3. see examples - [integration examples](examples/integration/)
4. optimize - [performance guide](advanced/performance.md)
5. test - [testing guide](advanced/testing.md)

---