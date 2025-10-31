# RPG Character Integration

Complete example integrating RPG progression components with stats, inventory, and quests.

## Components Used

**RPG**: StatsComponent, ExperienceComponent, InventoryComponent, QuestComponent, DialogueComponent, SkillTreeComponent
**Core**: HealthComponent, VelocityComponent, MovementComponent, SaveComponent
**Combat**: HurtBoxComponent, WeaponComponent

## Complete RPG Character

```gdscript
# RPGCharacter.gd
extends CharacterBody2D

@onready var health = $HealthComponent
@onready var velocity_comp = $VelocityComponent
@onready var movement = $MovementComponent
@onready var stats = $StatsComponent
@onready var experience = $ExperienceComponent
@onready var inventory = $InventoryComponent
@onready var quest = $QuestComponent
@onready var skill_tree = $SkillTreeComponent
@onready var hurt_box = $HurtBoxComponent
@onready var weapon = $WeaponComponent
@onready var save = $SaveComponent
@onready var audio = $AudioComponent
@onready var ui = $UIComponent

func _ready():
    _setup_core_systems()
    _setup_rpg_systems()
    _setup_progression()
    _setup_save_system()

func _setup_core_systems():
    movement.set_velocity_component(velocity_comp)
    hurt_box.set_health_component(health)
    stats.stat_changed.connect(_on_stat_changed)
    _update_health_from_stats()

func _setup_rpg_systems():
    stats.set_stat("strength", 10)
    stats.set_stat("dexterity", 10)
    stats.set_stat("intelligence", 10)
    stats.set_stat("constitution", 10)
    
    inventory.item_added.connect(_on_item_added)
    inventory.item_equipped.connect(_on_item_equipped)
    inventory.item_unequipped.connect(_on_item_unequipped)
    
    quest.quest_started.connect(_on_quest_started)
    quest.quest_completed.connect(_on_quest_completed)

func _setup_progression():
    experience.set_stats_component(stats)
    skill_tree.set_experience_component(experience)
    experience.level_up.connect(_on_level_up)
    experience.experience_gained.connect(_on_experience_gained)
    skill_tree.skill_unlocked.connect(_on_skill_unlocked)

func _setup_save_system():
    save.add_component_data("stats", stats)
    save.add_component_data("experience", experience)
    save.add_component_data("inventory", inventory)
    save.add_component_data("quest", quest)
    save.add_component_data("skill_tree", skill_tree)
    experience.level_up.connect(_auto_save)
    quest.quest_completed.connect(_auto_save)

# Stat System
func _update_health_from_stats():
    var constitution = stats.get_stat("constitution")
    health.set_max_health(100 + (constitution * 10))

func _on_stat_changed(stat_name: String, old_value: float, new_value: float):
    match stat_name:
        "constitution": _update_health_from_stats()
        "strength": _update_damage_from_stats()
        "dexterity": _update_speed_from_stats()

func _update_damage_from_stats():
    if weapon:
        var strength = stats.get_stat("strength")
        weapon.set_damage(weapon.get_base_damage() + strength * 0.5)

func _update_speed_from_stats():
    var dexterity = stats.get_stat("dexterity")
    velocity_comp.set_max_speed(200.0 + dexterity * 2.0)

# Experience & Leveling
func _on_experience_gained(amount: int):
    ui.show_notification("+%d XP" % amount, Color.YELLOW)
    audio.play_sound("experience_gain")

func _on_level_up(new_level: int):
    ui.show_notification("LEVEL UP! Level %d" % new_level, Color.GOLD)
    audio.play_sound("level_up")
    health.heal(health.max_health)
    stats.add_stat_points(5)

func gain_experience(amount: int):
    experience.add_experience(amount)

# Inventory System
func _on_item_added(item: Dictionary):
    ui.show_notification("Obtained: %s" % item.name, Color.GREEN)
    audio.play_sound("item_pickup")

func _on_item_equipped(item: Dictionary, slot: String):
    ui.show_notification("Equipped: %s" % item.name, Color.CYAN)
    audio.play_sound("item_equip")
    _apply_item_bonuses(item, true)

func _on_item_unequipped(item: Dictionary, slot: String):
    _apply_item_bonuses(item, false)

func _apply_item_bonuses(item: Dictionary, apply: bool):
    if not item.has("bonuses"):
        return
    
    var multiplier = 1 if apply else -1
    for stat_name in item.bonuses:
        var bonus = item.bonuses[stat_name] * multiplier
        stats.set_stat(stat_name, stats.get_stat(stat_name) + bonus)

# Quest System
func _on_quest_started(quest_id: String):
    var quest_data = quest.get_quest(quest_id)
    ui.show_notification("New Quest: %s" % quest_data.title, Color.YELLOW)
    audio.play_sound("quest_start")

func _on_quest_completed(quest_id: String):
    var quest_data = quest.get_quest(quest_id)
    ui.show_notification("Quest Complete: %s" % quest_data.title, Color.GOLD)
    audio.play_sound("quest_complete")
    
    if quest_data.has("experience_reward"):
        gain_experience(quest_data.experience_reward)
    
    if quest_data.has("gold_reward"):
        inventory.add_gold(quest_data.gold_reward)
    
    if quest_data.has("item_rewards"):
        for item in quest_data.item_rewards:
            inventory.add_item(item)

# Skill Tree System
func _on_skill_unlocked(skill_id: String):
    var skill_data = skill_tree.get_skill(skill_id)
    ui.show_notification("Skill Unlocked: %s" % skill_data.name, Color.PURPLE)
    audio.play_sound("skill_unlock")
    _apply_skill_effects(skill_data)

func _apply_skill_effects(skill_data: Dictionary):
    if skill_data.has("stat_bonuses"):
        for stat_name in skill_data.stat_bonuses:
            var bonus = skill_data.stat_bonuses[stat_name]
            stats.set_stat(stat_name, stats.get_stat(stat_name) + bonus)

# Save System
func _auto_save():
    save.save_data()

func save_game():
    save.save_data()
    ui.show_notification("Game Saved", Color.GREEN)
    audio.play_sound("save")

func load_game():
    if save.load_data():
        ui.show_notification("Game Loaded", Color.GREEN)
        _update_health_from_stats()
        _update_damage_from_stats()
        _update_speed_from_stats()
```

## Scene Tree Structure

```bash
RPGCharacter (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── HealthComponent
├── VelocityComponent
├── MovementComponent
├── StatsComponent
├── ExperienceComponent
├── InventoryComponent
├── QuestComponent
├── SkillTreeComponent
├── HurtBoxComponent (Area2D)
├── WeaponComponent
├── SaveComponent
├── AudioComponent
└── UIComponent
```

## Step-by-Step Integration

### Step 1: Basic Stats

```gdscript
@onready var stats = $StatsComponent

func _ready():
    stats.set_stat("strength", 10)
    stats.set_stat("constitution", 10)
```

### Step 2: Health Scaling

```gdscript
@onready var health = $HealthComponent
@onready var stats = $StatsComponent

func _ready():
    stats.stat_changed.connect(_on_stat_changed)
    _update_health_from_stats()

func _update_health_from_stats():
    var constitution = stats.get_stat("constitution")
    health.set_max_health(100 + (constitution * 10))
```

### Step 3: Experience

```gdscript
@onready var experience = $ExperienceComponent

func _ready():
    experience.set_stats_component(stats)
    experience.level_up.connect(_on_level_up)

func _on_level_up(new_level: int):
    health.heal(health.max_health)
```

### Step 4: Inventory

```gdscript
@onready var inventory = $InventoryComponent

func _ready():
    inventory.item_equipped.connect(_on_item_equipped)

func _on_item_equipped(item: Dictionary, slot: String):
    if item.has("bonuses"):
        for stat_name in item.bonuses:
            stats.set_stat(stat_name, stats.get_stat(stat_name) + item.bonuses[stat_name])
```

### Step 5: Quests

```gdscript
@onready var quest = $QuestComponent

func _ready():
    quest.quest_completed.connect(_on_quest_completed)

func _on_quest_completed(quest_id: String):
    var quest_data = quest.get_quest(quest_id)
    if quest_data.has("experience_reward"):
        experience.add_experience(quest_data.experience_reward)
```

## Common RPG Patterns

### Stat-Based Damage

```gdscript
func calculate_damage() -> float:
    var base_damage = weapon.get_base_damage()
    var strength = stats.get_stat("strength")
    return base_damage + strength * 0.5
```

### Critical Hit System

```gdscript
func try_critical_hit() -> bool:
    var dexterity = stats.get_stat("dexterity")
    var crit_chance = min(dexterity * 0.5, 50.0)
    return randf() * 100.0 < crit_chance
```

### Skill Requirements

```gdscript
func can_unlock_skill(skill_id: String) -> bool:
    var skill_data = skill_tree.get_skill(skill_id)
    
    if experience.get_level() < skill_data.required_level:
        return false
    
    if skill_data.has("required_stats"):
        for stat_name in skill_data.required_stats:
            if stats.get_stat(stat_name) < skill_data.required_stats[stat_name]:
                return false
    
    return true
```

### Equipment Sets

```gdscript
func check_set_bonuses():
    var equipped_items = inventory.get_equipped_items()
    var set_pieces = {}
    
    for item in equipped_items.values():
        if item.has("set_name"):
            set_pieces[item.set_name] = set_pieces.get(item.set_name, 0) + 1
    
    for set_name in set_pieces:
        if set_pieces[set_name] >= 4:
            stats.add_modifier("set_bonus_" + set_name, {
                "strength": 5,
                "constitution": 5
            })
```

## Testing Checklist

- [ ] Stats affect character attributes
- [ ] Experience and level ups work
- [ ] Inventory adds/removes items
- [ ] Equipment applies bonuses
- [ ] Quests track and reward
- [ ] Skills unlock and upgrade
- [ ] Save/load preserves data

## Performance Tips

1. **Stat Caching**: Cache calculated values, recalculate on changes only
2. **Inventory Limits**: Set reasonable size limits
3. **Save Throttling**: Limit auto-save frequency

## Common Issues

**Stats don't update health**: Verify stat_changed signal connection

**Items don't apply bonuses**: Check item data structure and item_equipped signal

**Save data corrupted**: Validate data before saving, use try/catch for load

**Experience doesn't level up**: Check experience thresholds and level_up signal

## Next Steps

- [Combat System](combat-system.md) for RPG combat
- [AI Entity](ai-entity.md) for NPCs
- [Performance Guide](../advanced/performance.md) for optimization
