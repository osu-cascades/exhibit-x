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

    pub fn update(&self, boundary: Rect) -> Ball {
        self.bounce_off_sides(boundary)
            .update_position()
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

    fn bounce_off_sides(&self, boundary: Rect) -> Ball {
        let Ball{ ellipse, velocity, .. } = *self;
        let rect = ellipse.rect;
        let [mut x, mut y] = velocity.to_array();

        if rect.left() <= boundary.left() ||  rect.right() >= boundary.right() {
            x *= -1.0; 
        }

        if rect.bottom() <= boundary.bottom() || rect.top() >= boundary.top()  {
            y *= -1.0;
        }

        let ellipse = Ellipse { rect, ..ellipse };
        let velocity = Vec2::new(x,y);
        Ball { velocity, ellipse, ..*self}
    }

    pub fn collide_with_balls(&self, others: &Vec<Ball>) -> Ball {
        others.iter().fold(*self, |acc, other| acc.collide_with_ball(other))
    }

    fn collide_with_ball(&self, other: &Ball) -> Ball{
        let d_pos =  self.center() - other.center();
        let distance = (d_pos.x * d_pos.x + d_pos.y * d_pos.y).sqrt();
        let min_dist = other.radius() + self.radius();
        if distance < min_dist && self != other && d_pos.x != 0.0 && d_pos.y != 0.0 {
            let velocity = self.velocity - (((self.velocity - other.velocity) * d_pos)/ (d_pos * d_pos)) * d_pos;
            Ball { velocity, ..*self }
        } else {
            Ball { ..*self }
        }
    }

    fn update_position(&self) -> Ball {
        let Ball{ ellipse, velocity, .. } = *self;
        let mut rect = ellipse.rect;

        rect = rect.shift(velocity);        
        
        let ellipse = Ellipse { rect, ..ellipse };

        Ball { ellipse, ..*self}
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