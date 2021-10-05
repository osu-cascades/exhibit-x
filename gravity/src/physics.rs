use core::fmt::Debug;
use nannou::prelude::Point2;

const GRAVITATIONAL_CONSTANT: f64 = 9.807;

pub trait Positional {
    fn position(&self) -> Point2;
}

pub trait Massive {
    fn apply_force(&mut self, force: Point2);
    fn mass(&self) -> f64;
}

pub struct Attractor {
    position: Point2,
    mass: f64,
}

impl Attractor {
    pub fn new(position: Point2, mass: f64) -> Self {
        Self { position, mass }
    }
}

impl Massive for Attractor {
    fn apply_force(&mut self, force: Point2) {
        () // Attractors cannot be moved by gravity
    }

    fn mass(&self) -> f64 {
        self.mass
    }
}

impl Positional for Attractor {
    fn position(&self) -> Point2 {
        self.position
    }
}

pub fn apply_gravity<M: Massive + Positional + Debug>(objects: &mut Vec<M>) {
    for target_index in 0..objects.len() {
        for other_index in 0..objects.len() {
            // Don't apply gravity to self
            if other_index == target_index {
                continue;
            }

            let target = &objects[target_index];
            let other = &objects[other_index];

            let distance = target.position().distance_squared(other.position()) as f64;

            // Prevents divide by zero when objects are on top of each other
            if distance == 0.0 {
                continue;
            }

            let force = ((target.mass() * other.mass()) / distance) * GRAVITATIONAL_CONSTANT;
            let direction = Point2::new(
                other.position().x - target.position().x,
                other.position().y - target.position().y,
            )
            .normalize_or_zero();
            objects[target_index].apply_force(direction * force as f32);
        }
    }
}
