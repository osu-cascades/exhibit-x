use nannou::prelude::*;
use nannou::color::rgb::Rgb;
use nannou::color::encoding::Srgb;
use nannou::geom::{Ellipse, Range};
use nannou::prelude::geom::ellipse::Circumference;
use nannou::rand::random;
use crate::person::Person;

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

    pub fn rand_velocity(&self) -> Ball {
        let velocity = Point2::new(
            (random::<f32>() - 0.5) * 4.0,
            (random::<f32>()) * -10.0
        );
        Ball {velocity, ..*self}
    }

    pub fn update(&self, boundary: Rect, person: &Person) -> Ball {
        self.bounce_off_sides(boundary)
            .colide(person)
            .apply_gravity()
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

    pub fn circumference(&self) -> Circumference<f32>{
        self.ellipse.circumference()
    }

    pub fn center(&self) -> Point2 {
        self.ellipse.rect.xy()
    }

    fn bounce_off_sides(&self, boundary: Rect) -> Ball {
        let Ball{ ellipse, velocity, .. } = *self;
        let mut rect = ellipse.rect;
        let [mut x, mut y] = velocity.to_array();

        if rect.left() <= boundary.left() {
            x *= -1.0; 
            rect = rect.align_left_of(boundary); 
        } else if rect.right() >= boundary.right() {
            x *= -1.0;
            rect = rect.align_right_of(boundary);
        }

        if rect.bottom() <= boundary.bottom() {
            y *= -0.9;
            rect = rect.align_bottom_of(boundary)
        }

        let ellipse = Ellipse { rect, ..ellipse };
        let velocity = Vec2::new(x,y);
        Ball { velocity, ellipse, ..*self}
    }

    fn apply_gravity(&self) -> Ball {
        let velocity = Vec2::new(self.velocity.x, self.velocity.y - 0.4);
        Ball { velocity, ..*self }
    }

    fn colide(&self, person: &Person) -> Ball {
        let velocity = match person.collition_angle(self){
            Some(deg) => self.velocity.rotate(deg),
            None => self.velocity
        };

        Ball {velocity, ..*self}
    }

    fn update_position(&self) -> Ball {
        let Ball{ ellipse, velocity, .. } = *self;
        let mut rect = ellipse.rect;

        rect = rect.shift(velocity);        
        
        let ellipse = Ellipse { rect, ..ellipse };

        Ball { ellipse, ..*self}
    }
}

pub struct Ball {
    ellipse: Ellipse,
    velocity: Point2,
    color:  Rgb<Srgb, u8>,
}
