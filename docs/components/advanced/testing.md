# Testing Components

Guide to testing component-based architecture in Godot using unit tests, integration tests, and edge case handling.

## Table of Contents

- [Overview](#overview)
- [Unit Testing Patterns](#unit-testing-patterns)
- [Integration Testing](#integration-testing)
- [Common Edge Cases](#common-edge-cases)
- [Testing Tools](#testing-tools)
- [Best Practices](#best-practices)

---

## Overview

Testing ensures components are robust, maintainable, and bug-free. This guide covers unit testing (isolated components), integration testing (component interactions), and edge case handling.

---

## Unit Testing Patterns

Test components in isolation using GUT (Godot Unit Test) framework.

### Basic Test Structure

```gdscript
# test_health_component.gd
extends GutTest

var health: HealthComponent

func before_each():
    health = HealthComponent.new()
    health.max_health = 100
    add_child_autofree(health)

func test_take_damage():
    health.take_damage(30)
    assert_eq(health.current_health, 70)

func test_health_depleted_signal():
    watch_signals(health)
    health.take_damage(100)
    assert_signal_emitted(health, "health_depleted")

func test_overheal_prevention():
    health.heal(50)
    assert_eq(health.current_health, 100)
```

### Testing Signals

```gdscript
func test_weapon_fire_signal():
    watch_signals(weapon)
    weapon.fire()
    assert_signal_emitted(weapon, "fired")
```

### Testing State

```gdscript
func test_state_change():
    state_machine.add_state("idle", func(): pass)
    state_machine.add_state("running", func(): pass)
    state_machine.change_state("idle")
    assert_eq(state_machine.current_state, "idle")
    
    state_machine.change_state("running")
    assert_eq(state_machine.current_state, "running")
```

### Testing Properties

```gdscript
func test_max_speed_limit():
    velocity.max_speed = 100
    velocity.accelerate(Vector2(200, 0))
    assert_lte(velocity.current_velocity.length(), 100)

func test_friction_application():
    velocity.friction = 0.5
    velocity.current_velocity = Vector2(100, 0)
    velocity.apply_friction(1.0)
    assert_lt(velocity.current_velocity.length(), 100)
```

---

## Integration Testing

Test component interactions in realistic scenarios.

### Combat System

```gdscript
extends GutTest

var player: CharacterBody2D
var enemy: CharacterBody2D

func before_each():
    player = preload("res://entities/player.tscn").instantiate()
    enemy = preload("res://entities/enemy.tscn").instantiate()
    add_child_autofree(player)
    add_child_autofree(enemy)

func test_damage_system():
    var player_health = player.get_node("HealthComponent")
    var enemy_hitbox = enemy.get_node("HitBoxComponent")
    
    enemy_hitbox.set_damage(25)
    player.get_node("HurtBoxComponent")._on_area_entered(enemy_hitbox)
    assert_eq(player_health.current_health, 75)

func test_death_system():
    var player_health = player.get_node("HealthComponent")
    watch_signals(player_health)
    player_health.take_damage(100)
    assert_signal_emitted(player_health, "health_depleted")
```

### Movement System

```gdscript
func test_movement_applies_velocity():
    velocity_comp.current_velocity = Vector2(100, 0)
    movement_comp.move(1.0)
    assert_gt(entity.position.x, 0)
```

### AI System

```gdscript
func test_target_detection_triggers_chase():
    var target = Node2D.new()
    target.position = Vector2(100, 0)
    add_child_autofree(target)
    
    watch_signals(detection)
    detection._on_detection_area_entered(target)
    
    assert_signal_emitted(detection, "target_detected")
    assert_eq(state_machine.current_state, "chase")
```

---

## Common Edge Cases

### HealthComponent

```gdscript
func test_negative_damage():
    health.take_damage(-20)
    assert_eq(health.current_health, 100)

func test_damage_exceeding_health():
    health.take_damage(150)
    assert_eq(health.current_health, 0)

func test_healing_at_max_health():
    health.heal(50)
    assert_eq(health.current_health, 100)

func test_zero_max_health():
    health.max_health = 0
    health.take_damage(10)
    assert_eq(health.current_health, 0)
```

### VelocityComponent

```gdscript
func test_zero_acceleration():
    velocity.accelerate(Vector2.ZERO)
    assert_eq(velocity.current_velocity, Vector2.ZERO)

func test_negative_friction():
    velocity.friction = -0.5
    velocity.current_velocity = Vector2(100, 0)
    velocity.apply_friction(1.0)
    assert_gte(velocity.current_velocity.length(), 0)

func test_instant_direction_change():
    velocity.current_velocity = Vector2(100, 0)
    velocity.accelerate(Vector2(-200, 0))
    assert_true(velocity.current_velocity.x < 0)
```

### TimerComponent

```gdscript
func test_restart_running_timer():
    timer.start_timer("test", 1.0)
    timer.start_timer("test", 1.0)
    assert_true(timer.is_timer_running("test"))

func test_stop_nonexistent_timer():
    timer.stop_timer("nonexistent")
    assert_false(timer.is_timer_running("nonexistent"))
```

### PathfindComponent

```gdscript
func test_unreachable_target():
    pathfind.set_target(Vector2(10000, 10000))
    pathfind.calculate_path()
    assert_eq(pathfind.get_path().size(), 0)
```

---

## Testing Tools

### GUT Framework

Use [GUT](https://github.com/bitwes/Gut) for automated testing.

**Installation**: Download from Asset Library, create `res://tests/` directory.

**Basic Setup**:

```gdscript
extends GutTest

func before_all():
    # Runs once before all tests
    pass

func before_each():
    # Runs before each test
    pass

func test_example():
    assert_true(true)
```

**Common Assertions**:

```gdscript
# Equality
assert_eq(actual, expected)
assert_ne(actual, expected)

# Comparison
assert_gt(actual, expected)
assert_lt(actual, expected)
assert_gte(actual, expected)
assert_lte(actual, expected)

# Boolean
assert_true(value)
assert_false(value)

# Null
assert_null(value)
assert_not_null(value)

# Signals
watch_signals(object)
assert_signal_emitted(object, "signal_name")
assert_signal_not_emitted(object, "signal_name")
```

**Running Tests**:

Via GUT Panel: Open GUT panel → Select test directory → Run All

Via CLI:

```bash
godot --headless --script res://addons/gut/gut_cmdln.gd -gtest=res://tests/
```

### Manual Testing Checklist

**Component Isolation**:

- [ ] Works in empty scene
- [ ] Properties exposed correctly
- [ ] Signals emit at expected times
- [ ] Handles missing dependencies

**Integration**:

- [ ] Integrates with dependencies
- [ ] Signals connect properly
- [ ] Responds to events
- [ ] Cleanup works correctly

**Performance**:

- [ ] Performs well with many instances
- [ ] No memory leaks
- [ ] Stable frame rate

**Edge Cases**:

- [ ] Handles null/invalid inputs
- [ ] Works at extreme values
- [ ] Recovers from errors

---

## Best Practices

### 1. Test One Thing

```gdscript
# Good
func test_health_decreases_on_damage():
    health.take_damage(25)
    assert_eq(health.current_health, 75)

# Bad - tests multiple behaviors
func test_health_system():
    health.take_damage(25)
    health.heal(10)
    health.take_damage(100)
```

### 2. Descriptive Names

```gdscript
# Good
func test_health_cannot_exceed_max_when_healing():
    pass

# Bad
func test_health():
    pass
```

### 3. Test Success and Failure

```gdscript
func test_valid_state_change_succeeds():
    state_machine.add_state("idle", func(): pass)
    state_machine.change_state("idle")
    assert_eq(state_machine.current_state, "idle")

func test_invalid_state_change_fails():
    state_machine.change_state("nonexistent")
    assert_eq(state_machine.current_state, "")
```

### 4. Clean Up

```gdscript
func after_each():
    for child in get_children():
        child.queue_free()
```

### 5. Use Fixtures

```gdscript
func create_test_entity() -> CharacterBody2D:
    var entity = CharacterBody2D.new()
    entity.add_child(HealthComponent.new())
    entity.add_child(VelocityComponent.new())
    return entity

func before_each():
    test_entity = create_test_entity()
    add_child_autofree(test_entity)
```

### 6. Test Signals

```gdscript
func test_damage_signal_emits_with_value():
    watch_signals(health)
    health.take_damage(25)
    assert_signal_emitted_with_parameters(health, "health_changed", [100, 75])
```

### 7. Mock Dependencies

```gdscript
class MockVelocityComponent extends VelocityComponent:
    var mock_velocity: Vector2 = Vector2.ZERO
    func get_velocity() -> Vector2:
        return mock_velocity

func test_movement_with_mock():
    var mock = MockVelocityComponent.new()
    mock.mock_velocity = Vector2(100, 0)
    movement.set_velocity_component(mock)
    movement.move(1.0)
```

---

## Summary

**Testing Workflow**:

1. Write unit tests (isolated components)
2. Write integration tests (component interactions)
3. Test edge cases
4. Manual testing (visual/performance)
5. Run tests regularly

**Key Takeaways**:

- Use GUT for automated testing
- Test isolation first, integration second
- Always test edge cases
- Keep tests simple and focused
- Use descriptive names
- Clean up resources

**When to Test**:

- After implementing new component
- Before refactoring
- When fixing bugs
- Before releases
