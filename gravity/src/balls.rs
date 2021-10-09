use nannou::prelude::*;
use crate::ball::Ball;

impl Balls {
    pub fn new(balls: Vec<Ball>) -> Balls {
        Balls {balls}
    }

    pub fn new_static() -> Balls {
        let balls = vec![Ball::new(Point2::new(-100.1, 100.1), 10.0, Point2::new(0.0, 0.0), RED), Ball::new(Point2::new(100.0, 100.0), 10.0, Point2::new(0.0, 0.0), BLUE)];
        Balls {balls}
    }

    pub fn update(&mut self, boundary: Rect) -> Balls {
        let mut balls = self.balls_collide().balls;
        for b in &mut balls {
            b.update(boundary);
        }
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

    pub fn balls_mut(&mut self) -> &mut Vec<Ball> {
        &mut self.balls
    }
}

pub struct Balls {
    balls : Vec<Ball>,
}