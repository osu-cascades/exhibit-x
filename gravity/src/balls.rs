use nannou::prelude::*;
use crate::ball::Ball;

impl Balls {
    pub fn new(balls: Vec<Ball>) -> Balls {
        Balls {balls}
    }

    pub fn new_static() -> Balls {
        let balls = vec![
            Ball::new(Point2::new(-100.0, 100.0), 10.0, Point2::new(0.0, 0.0), RED),
            Ball::new(Point2::new(100.0, 100.0), 10.0, Point2::new(0.0, 0.0), BLUE),
            Ball::new(Point2::new(100.0, 0.0), 10.0, Point2::new(0.0, 0.0), YELLOW),           
            ];
        Balls {balls}
    }

    pub fn update(&mut self, boundary: Rect) {
        self.balls_collide();
        for b in &mut self.balls {
            b.update(boundary);
        }
    }

    pub fn draw(&self, draw: &Draw) {
        for b in self.balls.iter() {
            b.draw(draw);
        }
    }

    fn balls_collide(&mut self) {
        let balls_clone = self.balls.clone(); 
        for b in &mut self.balls {
            b.collide_with_balls(&balls_clone);
        }
    }

    pub fn balls_mut(&mut self) -> &mut Vec<Ball> {
        &mut self.balls
    }
}

pub struct Balls {
    balls : Vec<Ball>,
}