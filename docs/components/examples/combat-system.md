# Combat System Integration

Complete example of integrating combat components into a functional combat entity.

## Overview

This guide shows how to wire together health, damage, weapons, and visual feedback components to create a complete combat system.

## Components Used

**Core Combat**:

- HealthComponent - Manages entity health
- HurtBoxComponent - Detects incoming damage
- HitBoxComponent - Deals damage to others
- WeaponComponent - Handles weapon firing

**Visual Feedback**:

- HealthBarComponent - Displays health visually
- FloatingTextComponent - Shows damage numbers
- BlinkComponent - Visual damage feedback
- AudioComponent - Sound effects
- ParticleComponent - Visual effects

**Movement** (if needed):

- VelocityComponent - Movement calculations
- MovementComponent - Applies movement

## Complete Combat Entity Example

```gdscript
# CombatEntity.gd - Full combat-capable entity
extends CharacterBody2D

# Core Components
@onready var health = $HealthComponent
@onready var velocity_comp = $VelocityComponent
@onready var movement = $MovementComponent
@onready var hurt_box = $HurtBoxComponent
@onready var hit_box = $HitBoxComponent
@onready var weapon = $WeaponComponent

# Visual Feedback Components
@onready var health_bar = $UI/HealthBarComponent
@onready var floating_text = $FloatingTextComponent
@onready var blink = $BlinkComponent
@onready var audio = $AudioComponent
@onready var particles = $ParticleComponent

func _ready():
    _setup_core_combat()
    _setup_visual_feedback()
    _setup_weapon_system()

func _setup_core_combat():
    """Initialize core combat components"""
    # Connect damage detection to health
    hurt_box.set_health_component(health)
    
    # Connect movement system
    movement.set_velocity_component(velocity_comp)
    
    # Connect health bar to health
    health_bar.set_health_component(health)
    
    # Listen for health changes
    health.health_changed.connect(_on_health_changed)
    health.health_depleted.connect(_on_death)

func _setup_visual_feedback():
    """Setup all visual and audio feedback"""
    # Damage feedback
    hurt_box.hurt.connect(_on_hurt)

func _setup_weapon_system():
    """Initialize weapon and attack systems"""
    weapon.fired.connect(_on_weapon_fired)
    weapon.reload_started.connect(_on_reload_started)
    weapon.reload_completed.connect(_on_reload_completed)

func _on_health_changed(old_health: float, new_health: float):
    """Handle health changes with visual feedback"""
    var damage = old_health - new_health
    
    if damage > 0:
        # Show damage number
        floating_text.show_text(str(int(damage)), Color.RED)
        
        # Visual feedback
        blink.start_blink()
        
        # Audio feedback
        audio.play_sound("hurt")
        
        # Particle effect
        particles.play_effect("blood_splatter")
    elif damage < 0:
        # Healing feedback
        floating_text.show_text("+" + str(int(abs(damage))), Color.GREEN)
        audio.play_sound("heal")
        particles.play_effect("heal_sparkle")

func _on_hurt(damage: float):
    """Additional hurt feedback beyond health changes"""
    # Screen shake for player
    if is_in_group("player"):
        get_tree().call_group("camera", "shake", damage * 0.1)

func _on_death():
    """Handle entity death"""
    # Death animation
    particles.play_effect("death_explosion")
    audio.play_sound("death")
    
    # Disable components
    hurt_box.set_enabled(false)
    hit_box.set_enabled(false)
    weapon.set_enabled(false)
    
    # Play death animation and queue free
    await get_tree().create_timer(1.0).timeout
    queue_free()

func _on_weapon_fired():
    """Weapon firing feedback"""
    audio.play_sound("weapon_fire")
    particles.play_effect("muzzle_flash")
    
    # Screen shake for player
    if is_in_group("player"):
        get_tree().call_group("camera", "shake", 0.2)

func _on_reload_started():
    """Reload start feedback"""
    audio.play_sound("reload_start")

func _on_reload_completed():
    """Reload complete feedback"""
    audio.play_sound("reload_complete")
    floating_text.show_text("RELOADED", Color.YELLOW)
```

## Scene Tree Structure

```
CombatEntity (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── HealthComponent
├── VelocityComponent
├── MovementComponent
├── HurtBoxComponent (Area2D)
│   └── CollisionShape2D
├── HitBoxComponent (Area2D)
│   └── CollisionShape2D
├── WeaponComponent
├── FloatingTextComponent
├── BlinkComponent
├── AudioComponent
├── ParticleComponent
└── UI
    └── HealthBarComponent
```

## Step-by-Step Integration

### Step 1: Basic Health System

```gdscript
# Start with just health
@onready var health = $HealthComponent

func _ready():
    health.health_depleted.connect(_on_death)

func _on_death():
    queue_free()
```

### Step 2: Add Damage Detection

```gdscript
# Add hurt box
@onready var health = $HealthComponent
@onready var hurt_box = $HurtBoxComponent

func _ready():
    hurt_box.set_health_component(health)
    health.health_depleted.connect(_on_death)
```

### Step 3: Add Visual Feedback

```gdscript
# Add health bar and damage numbers
@onready var health = $HealthComponent
@onready var hurt_box = $HurtBoxComponent
@onready var health_bar = $UI/HealthBarComponent
@onready var floating_text = $FloatingTextComponent

func _ready():
    hurt_box.set_health_component(health)
    health_bar.set_health_component(health)
    health.health_changed.connect(_on_health_changed)

func _on_health_changed(old_health: float, new_health: float):
    var damage = old_health - new_health
    if damage > 0:
        floating_text.show_text(str(int(damage)), Color.RED)
```

### Step 4: Add Audio and Particles

```gdscript
# Complete feedback system
@onready var audio = $AudioComponent
@onready var particles = $ParticleComponent

func _on_health_changed(old_health: float, new_health: float):
    var damage = old_health - new_health
    if damage > 0:
        floating_text.show_text(str(int(damage)), Color.RED)
        audio.play_sound("hurt")
        particles.play_effect("blood_splatter")
```

### Step 5: Add Weapon System

```gdscript
# Add weapon with feedback
@onready var weapon = $WeaponComponent

func _ready():
    # ... previous setup ...
    weapon.fired.connect(_on_weapon_fired)

func _on_weapon_fired():
    audio.play_sound("weapon_fire")
    particles.play_effect("muzzle_flash")
```

## Common Patterns

### Damage Feedback Chain

```gdscript
# Complete damage feedback sequence
func _on_health_changed(old_health: float, new_health: float):
    var damage = old_health - new_health
    
    if damage > 0:
        # 1. Visual number
        floating_text.show_text(str(int(damage)), Color.RED)
        
        # 2. Flash effect
        blink.start_blink()
        
        # 3. Sound
        audio.play_sound("hurt")
        
        # 4. Particles
        particles.play_effect("blood_splatter")
        
        # 5. Camera shake (if player)
        if is_in_group("player"):
            get_tree().call_group("camera", "shake", damage * 0.1)
```

### Critical Hit System

```gdscript
# Enhanced damage with critical hits
func _on_health_changed(old_health: float, new_health: float):
    var damage = old_health - new_health
    
    if damage > 0:
        # Check if critical hit (example: damage > 50)
        var is_critical = damage > 50
        
        if is_critical:
            floating_text.show_text("CRITICAL! " + str(int(damage)), Color.ORANGE)
            audio.play_sound("critical_hit")
            particles.play_effect("critical_explosion")
            blink.start_blink(Color.ORANGE, 0.3)
        else:
            floating_text.show_text(str(int(damage)), Color.RED)
            audio.play_sound("hurt")
            particles.play_effect("blood_splatter")
            blink.start_blink()
```

### Invincibility Frames

```gdscript
# Add invincibility after taking damage
var is_invincible: bool = false
const INVINCIBILITY_DURATION = 1.0

func _on_hurt(damage: float):
    if is_invincible:
        return
    
    # Apply damage feedback
    floating_text.show_text(str(int(damage)), Color.RED)
    blink.start_blink()
    
    # Enable invincibility
    is_invincible = true
    hurt_box.set_enabled(false)
    
    # Disable after duration
    await get_tree().create_timer(INVINCIBILITY_DURATION).timeout
    is_invincible = false
    hurt_box.set_enabled(true)
```

## Testing Checklist

- [ ] Entity takes damage correctly
- [ ] Health bar updates in real-time
- [ ] Damage numbers appear and fade
- [ ] Blink effect plays on damage
- [ ] Sound effects play correctly
- [ ] Particle effects spawn at right position
- [ ] Death sequence completes properly
- [ ] Weapon fires and reloads correctly
- [ ] Invincibility frames work (if implemented)
- [ ] Critical hits display differently (if implemented)

## Performance Tips

1. **Object Pooling**: Pool particle effects and floating text for better performance
2. **Audio Limiting**: Limit simultaneous hurt sounds to prevent audio spam
3. **Particle Limits**: Set max particles for blood splatters
4. **Conditional Feedback**: Disable expensive feedback for off-screen entities

## Common Issues

**Issue**: Damage numbers don't appear

- Check FloatingTextComponent is child of entity
- Verify health_changed signal is connected
- Ensure floating_text reference is valid

**Issue**: Multiple hurt sounds play at once

- Add cooldown to audio playback
- Use audio bus limiting
- Check for duplicate signal connections

**Issue**: Entity doesn't die

- Verify health_depleted signal connection
- Check if health reaches exactly 0
- Ensure _on_death() is being called

## Next Steps

- Add [AI Entity Integration](ai-entity.md) for enemy behavior
- Implement [RPG Character Integration](rpg-character.md) for progression
- Optimize with [Performance Guide](../advanced/performance.md)
