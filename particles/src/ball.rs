// mod point;

use nannou::prelude::*;
use std::cmp::max;
use crate::point::Point;

impl Ball {
    pub fn update(&self, boundary: Rect) -> Ball {
        self.update_velocity(boundary).update_position(boundary)
    }

    pub fn draw(&self, draw: &Draw) {
        let Ball{ position, radius, .. } = *self;
        let Point{ x, y } = position;

        draw.ellipse().radius(radius).color(STEELBLUE).x_y(x, y);
    }

    fn update_velocity(&self, boundary: Rect) -> Ball {
        let Ball{ position, velocity, ..} = self;
        let mut velocity = velocity.clone();

        if position.x <= boundary.left() || position.x >= boundary.right() {
            velocity.x *= -1.0; 
        }

        if position.y <= boundary.bottom() || position.y >= boundary.top() {
            velocity.y *= -1.0; 
        }

        if position.y <= boundary.bottom() {
            velocity.y *= 0.9;
        }

        velocity.y -= 0.1;

        Ball { velocity, ..*self }
    }

    fn update_position(&self, boundary: Rect) -> Ball {
        let Ball{ position, velocity, .. } = self;
        let position = Point {
            x: position.x + velocity.x,
            y: max((position.y + velocity.y) as i32, boundary.bottom() as i32) as f32 // why df isn't Ord impilented for f32?!
        };

        Ball {position, ..*self}
    }

    // fn left(&self) -> f32 {
    //     let
    // }
}

#[derive(Copy, Clone)]
pub struct Ball {
    pub position: Point,
    pub velocity: Point,
    pub radius: f32,
}
