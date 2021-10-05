use nannou::prelude::*;
use crate::ball::Ball;
use crate::person::Person;

impl Balls {
    pub fn new(amount: i32, radiuses: f32) -> Balls {
        let balls = (0..amount).map(|_| Ball::new(Point2::new(0.0, 250.0), radiuses, Point2::new(1.5, -10.0), RED).rand_velocity()).collect();
        Balls {balls}
    }

    pub fn new_static() -> Balls {
        let balls = vec![Ball::new(Point2::new(-100.0, 100.0), 5.0, Point2::new(0.0, 0.0), RED), Ball::new(Point2::new(100.0, 100.0), 5.0, Point2::new(0.0, 0.0), RED)];
        Balls {balls}
    }

    pub fn update(&self, boundary: Rect, person: &Person) -> Balls {
        let balls = self.balls
            .iter()
            .map(|b| (*b).update(boundary, person))
            .collect();
        Balls {balls}
    }

    pub fn draw(&self, draw: &Draw) {
        for b in self.balls.iter() {
            b.draw(draw);
        }
    }

    pub fn balls_mut(&mut self) -> &mut Vec<Ball> {
        &mut self.balls
    }
}

pub struct Balls {
    balls : Vec<Ball>,
}