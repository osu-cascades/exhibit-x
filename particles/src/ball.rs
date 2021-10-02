use nannou::prelude::*;
use nannou::color::rgb::Rgb;
use nannou::color::encoding::Srgb;
use nannou::geom::Ellipse;
use nannou::prelude::geom::Range;
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
            (random::<f32>()) * -20.0
        );
        Ball {velocity, ..*self}
    }

    pub fn update(&self, boundary: Rect, person: &Person) -> Ball {
        self.update_velocity(boundary, person).update_position(boundary)
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

    fn update_velocity(&self, boundary: Rect, person: &Person) -> Ball {
        let Ball{ ellipse: Ellipse { rect, .. }, mut velocity, ..} = *self;

        if rect.left() <= boundary.left() || rect.right() >= boundary.right() {
            velocity.x *= -1.0; 
        }

        if rect.bottom() <= boundary.bottom() || self.colide(person) {
            velocity.y *= -0.9;
        }

        velocity.y -= 0.4;

        Ball { velocity, ..*self }
    }

    fn colide(&self, person: &Person) -> bool {
        self.ellipse.circumference().any(|p| person.contains(Point2::from_slice(&p)))
    }

    fn update_position(&self, boundary: Rect) -> Ball {
        let Ball{ ellipse, velocity, .. } = *self;
        let mut rect = ellipse.rect;

        if rect.bottom() <= boundary.bottom() {
            rect = rect.align_bottom_of(boundary);
        }

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
