use nannou::prelude::*;
use nannou::color::rgb::Rgb;
use nannou::color::encoding::Srgb;
use nannou::geom::{Ellipse, Range};
use crate::Drawable;
use crate::physics::{Massive, Positional};

impl Ball {
    pub fn new(position: Point2, radius: f32, velocity: Point2, color: Rgb<Srgb, u8>) -> Ball {
        let [x, y] = position.to_array();
        Ball {
            velocity,
            color,
            ellipse: Ellipse {
                rect: Rect {
                    x: Range { 
                        start: x - radius,
                        end: x + radius
                    },
                    y: Range {
                        start: y - radius,
                        end: y + radius
                    }
                },
                resolution: 10.0,
            }
        }
    }

    pub fn update(&mut self, boundary: Rect) {
        self.bounce_off_sides(boundary);
        self.update_position();
    }

    pub fn draw(&self, draw: &Draw) {
        let Ball{ color, ellipse, .. } = *self;
        let rect = ellipse.rect;
        let (x, y) = rect.x_y();

        draw.ellipse()
            .radius(rect.w())
            .color(color)
            .x_y(x, y);
    }

    pub fn center(&self) -> Point2 {
        self.ellipse.rect.xy()
    }

    fn radius(&self) -> f32 {
        self.ellipse.rect.w()
    }

    fn bounce_off_sides(&mut self, boundary: Rect) {
        let Ball{ ellipse, velocity, .. } = self;
        let rect = ellipse.rect;
        let [mut x, mut y] = velocity.to_array();

        if rect.left() <= boundary.left() ||  rect.right() >= boundary.right() {
            x *= -1.0; 
        }

        if rect.bottom() <= boundary.bottom() || rect.top() >= boundary.top()  {
            y *= -1.0;
        }

        self.velocity = Vec2::new(x,y);
    }

    pub fn collide_with_balls(&mut self, others: &Vec<Ball>) {
        for o in others {
            self.collide_with_ball(o);
        }
    }

    fn collide_with_ball(&mut self, other: &Ball){
        let d_pos =  self.center() - other.center();
        let distance = (d_pos.x * d_pos.x + d_pos.y * d_pos.y).sqrt();
        let min_dist = other.radius() + self.radius();
        if distance < min_dist && self != other && d_pos.x != 0.0 && d_pos.y != 0.0 {
            // maybe add mass at some point
            self.velocity = self.velocity - (((self.velocity - other.velocity) * d_pos)/ (d_pos * d_pos)) * d_pos;
        }
    }

    fn update_position(&mut self) {
        let Ball{ ellipse, velocity, .. } = self;

        self.ellipse.rect = ellipse.rect.shift(*velocity);        
    }
}

#[derive(PartialEq, Copy, Clone, Debug)]
pub struct Ball {
    ellipse: Ellipse,
    velocity: Point2,
    color:  Rgb<Srgb, u8>,
}

impl Massive for Ball {
    fn apply_force(&mut self, force: Point2) {
        self.velocity += force;
    }

    fn mass(&self) -> f64 {
        1.4
    }
}

impl Drawable for Ball {
    fn draw(&self, draw_context: &Draw) {
        self.draw(draw_context);
    }
}

impl Positional for Ball {
    fn position(&self) -> Point2 {
        self.center()
    }
}