import 'package:flame/components.dart';

// --- Interfaces (Interface Segregation Principle) ---

abstract interface class IMoveable {
  Vector2 get velocity;
  set velocity(Vector2 value);

  double get speed;
  set speed(double value);
}

abstract interface class IDamageable {
  int get health;
  void takeDamage(int amount);
  void onDeath();
}

// --- Mixins (Composition over Inheritance) ---

mixin MovementBehavior on PositionComponent implements IMoveable {
  @override
  Vector2 velocity = Vector2.zero();

  @override
  double speed = 100.0;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * speed * dt;
  }
}

mixin HealthBehavior on Component implements IDamageable {
  @override
  int health = 100;

  @override
  void takeDamage(int amount) {
    health -= amount;
    if (health <= 0) {
      onDeath();
    }
  }

  @override
  void onDeath() {
    if (this is PositionComponent) {
      (this as PositionComponent).removeFromParent();
    }
  }
}
