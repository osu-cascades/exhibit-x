use nannou::prelude::*;
use crate::ball::Ball;

impl Balls {
    pub fn new(amount: i32, radiuses: f32) -> Balls {
        let balls = (0..amount).map(|i| Ball::new(Point2::new(0.0 + 60.0 * i as f32, 250.0), radiuses, Point2::new(1.5, -10.0), RED).rand_velocity()).collect();
        Balls {balls}
    }

    pub fn update(&self, boundary: Rect) -> Balls {
        let balls = 
            self
            .balls_collide()
            .balls
            .iter()
            .map(|b| (*b).update(boundary))
            .collect();
        Balls {balls}
    }

    pub fn draw(&self, draw: &Draw) {
        for b in self.balls.iter() {
            b.draw(draw);
        }
    }

    fn balls_collide(&self) -> Balls {
        let balls = self.balls.iter().map(|b| b.collide_with_balls(&self.balls)).collect();
        Balls { balls }
    }
}

pub struct Balls {
    balls : Vec<Ball>,
}