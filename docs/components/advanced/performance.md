# Performance Optimization Guide

Understanding performance characteristics and optimization strategies for component-based architecture in Godot.

## Overview

While composition offers many benefits, it's important to understand its performance characteristics and how to optimize component-based architectures effectively.

## Performance Characteristics

### Memory Overhead

**Component-based approach:**

```bash
Enemy (CharacterBody2D)
├─ HealthComponent (Node) ~200 bytes overhead
├─ VelocityComponent (Node) ~200 bytes overhead
├─ MovementComponent (Node) ~200 bytes overhead
└─ HurtboxComponent (Area2D) ~300 bytes overhead
Total: ~900 bytes overhead for components
```

**Inheritance approach:**

```bash
Enemy (BaseEnemy extends CharacterBody2D)
Total: ~200 bytes overhead (just the base node)
```

**Impact:**

- ✅ Negligible for most games (< 1000 entities)
- ⚠️ Consider for games with 10,000+ entities
- 💡 Solution: Use object pooling for large entity counts

### Call Overhead

**Component method calls have indirection:**

```gdscript
# Composition: Two indirections
enemy.health.take_damage(10)  # enemy → health component → method

# Inheritance: One indirection
enemy.take_damage(10)  # enemy → method
```

**Benchmarks (approximate):**

- Direct method call: ~1-2 nanoseconds
- Component method call: ~3-5 nanoseconds
- Signal emission: ~50-100 nanoseconds

**Impact:**

- ✅ Negligible for most gameplay code
- ⚠️ Matters in tight loops (thousands of calls per frame)
- 💡 Solution: Cache references, use direct calls in hot paths

### Signal Performance

**Signals have overhead:**

```gdscript
# Signal emission + connection
health.damage_taken.emit(10)  # ~50-100ns
# vs
_on_damage_taken(10)  # ~1-2ns (direct call)
```

**Impact:**

- ✅ Fine for gameplay events (damage, death, etc.)
- ⚠️ Avoid in _physics_process for every entity
- 💡 Solution: Use direct method calls for high-frequency updates

## Optimization Strategies

### Strategy 1: Cache Component References

```gdscript
# ❌ Bad: Repeated lookups
func _physics_process(delta):
    $HealthComponent.update(delta)  # Lookup every frame
    $MovementComponent.update(delta)  # Lookup every frame

# ✅ Good: Cache references
@onready var health: HealthComponent = $HealthComponent
@onready var movement: MovementComponent = $MovementComponent

func _physics_process(delta):
    health.update(delta)  # Direct reference
    movement.update(delta)  # Direct reference
```

**Performance gain:** ~10-20% in tight loops

### Strategy 2: Use Direct Calls for Hot Paths

```gdscript
# ❌ Bad: Signals in tight loops
func _physics_process(delta):
    for enemy in enemies:
        enemy.health.damage_taken.connect(_on_damage)  # Signal overhead
        enemy.health.take_damage(1)

# ✅ Good: Direct calls for frequent operations
func _physics_process(delta):
    for enemy in enemies:
        enemy.health.take_damage(1)  # Direct call
        if enemy.health.current_health <= 0:
            _on_enemy_death(enemy)  # Direct call
```

**Performance gain:** ~5-10x faster in tight loops

### Strategy 3: Batch Component Updates

```gdscript
# ❌ Bad: Update each component individually
func _physics_process(delta):
    for enemy in enemies:
        enemy.health.update(delta)
        enemy.movement.update(delta)
        enemy.ai.update(delta)

# ✅ Good: Batch similar components
func _physics_process(delta):
    # Update all health components together (better cache locality)
    for enemy in enemies:
        enemy.health.update(delta)
    
    # Update all movement components together
    for enemy in enemies:
        enemy.movement.update(delta)
    
    # Update all AI components together
    for enemy in enemies:
        enemy.ai.update(delta)
```

**Performance gain:** ~20-30% due to better CPU cache usage

### Strategy 4: Disable Inactive Components

```gdscript
# Component with enable/disable
class_name PathfindComponent
extends Node

var enabled: bool = true

func set_enabled(value: bool) -> void:
    enabled = value
    set_process(value)  # Disable _process when not needed

func _process(delta):
    if not enabled:
        return
    # Pathfinding logic...

# Enemy.gd
func _on_death():
    pathfind.set_enabled(false)  # Stop processing
    movement.set_enabled(false)
```

**Performance gain:** Significant for inactive entities

### Strategy 5: Use Object Pooling

```gdscript
# ComponentPool.gd - Reuse component instances
class_name ComponentPool
extends Node

var pool: Array[Node] = []
var component_scene: PackedScene

func get_component() -> Node:
    if pool.is_empty():
        return component_scene.instantiate()
    return pool.pop_back()

func return_component(component: Node) -> void:
    component.get_parent().remove_child(component)
    pool.append(component)

# Usage
var health_pool: ComponentPool

func spawn_enemy():
    var enemy = Enemy.new()
    var health = health_pool.get_component()
    enemy.add_child(health)

func despawn_enemy(enemy):
    health_pool.return_component(enemy.health)
    enemy.queue_free()
```

**Performance gain:** ~50-80% reduction in allocation overhead

## Performance Comparison

**Scenario: 1000 enemies, each taking damage every frame**

```gdscript
# Inheritance approach: ~0.5ms per frame
for enemy in enemies:
    enemy.take_damage(1)

# Naive composition: ~0.8ms per frame
for enemy in enemies:
    enemy.health.take_damage(1)  # Component indirection

# Optimized composition: ~0.5ms per frame
for enemy in enemies:
    enemy.health.take_damage(1)  # Cached reference + inlined

# With signals: ~5.0ms per frame
for enemy in enemies:
    enemy.health.damage_taken.emit(1)  # Signal overhead
```

**Conclusion:** Optimized composition performs similarly to inheritance

## When to Optimize

### Don't Optimize Prematurely

- ✅ Start with clean, maintainable composition
- ✅ Profile to find actual bottlenecks
- ✅ Optimize only hot paths

### Optimize When

- ⚠️ Profiler shows component calls in top 10 bottlenecks
- ⚠️ Frame time exceeds budget (16.6ms for 60 FPS)
- ⚠️ Thousands of entities with frequent updates

### Don't Optimize When

- ✅ Game runs at target framerate
- ✅ Component calls not in profiler top 10
- ✅ Fewer than 100 entities

## Profiling Component Performance

```gdscript
# Use Godot's built-in profiler
func _physics_process(delta):
    var start_time = Time.get_ticks_usec()
    
    # Your component updates
    for enemy in enemies:
        enemy.health.update(delta)
    
    var elapsed = Time.get_ticks_usec() - start_time
    if elapsed > 1000:  # More than 1ms
        print("Health updates took: ", elapsed, "μs")
```

**Key metrics to watch:**

- Frame time (should be < 16.6ms for 60 FPS)
- Component update time
- Signal emission time
- Memory allocations per frame

## Best Practices

### DO

- ✅ Cache component references with `@onready`
- ✅ Use direct method calls for high-frequency operations
- ✅ Disable components when entities are inactive
- ✅ Profile before optimizing
- ✅ Use object pooling for frequently spawned entities
- ✅ Batch similar component updates together

### DON'T

- ❌ Use signals in tight loops (thousands per frame)
- ❌ Look up components repeatedly (`$ComponentName`)
- ❌ Create/destroy components every frame
- ❌ Optimize without profiling first
- ❌ Sacrifice code clarity for micro-optimizations

## Performance vs Maintainability Trade-offs

### Scenario 1: Gameplay Events (Damage, Death, etc.)

- **Frequency:** ~10-100 times per second
- **Recommendation:** Use signals for clean architecture
- **Reason:** Performance impact negligible, maintainability crucial

### Scenario 2: Physics Updates (Movement, Collision)

- **Frequency:** ~1000-10000 times per second
- **Recommendation:** Use direct method calls
- **Reason:** Performance matters, still maintainable

### Scenario 3: Particle Systems (Thousands of particles)

- **Frequency:** ~10000+ times per second
- **Recommendation:** Consider data-oriented design or custom solution
- **Reason:** Component overhead too high for this scale

## Real-World Performance Tips

### For Small Games (< 100 entities)

- Don't worry about component overhead
- Focus on clean architecture
- Use signals freely

### For Medium Games (100-1000 entities)

- Cache component references
- Use direct calls in _physics_process
- Profile occasionally

### For Large Games (1000+ entities)

- Implement object pooling
- Batch component updates
- Consider ECS for massive entity counts
- Profile regularly

## The Bottom Line

**Composition is fast enough for 99% of games when used correctly:**

- Modern CPUs handle component indirection easily
- Memory overhead is minimal for typical entity counts
- Maintainability benefits far outweigh minor performance costs
- Optimize only when profiling shows actual bottlenecks

**Focus on:**

1. Clean, maintainable architecture first
2. Profile to find real bottlenecks
3. Optimize hot paths only
4. Keep code readable even after optimization

## Next Steps

- Review [Component Patterns](../component-patterns.md) for best practices
- Check [Testing Guide](testing.md) for performance testing
- See [Integration Examples](../examples/integration/) for optimized patterns
