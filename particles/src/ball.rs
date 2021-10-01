use nannou::prelude::*;
use nannou::color::rgb::Rgb;
use nannou::color::encoding::Srgb;
use nannou::geom::Ellipse;
use nannou::prelude::geom::Range;
use nannou::glam::Vec2;

impl Ball {
    pub fn new(position: Vec2, radius: f32, velocity: Vec2, color: Rgb<Srgb, u8>) -> Ball {
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
        self.update_velocity(boundary).update_position(boundary)
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

    fn update_velocity(&self, boundary: Rect) -> Ball {
        let Ball{ ellipse, velocity, ..} = self;
        let rect = ellipse.rect;
        let mut velocity = velocity.clone();

        if rect.left() <= boundary.left() || rect.right() >= boundary.right() {
            velocity.x *= -1.0; 
        }

        if rect.bottom() <= boundary.bottom() {
            velocity.y *= -0.9;
        }

        velocity.y -= 0.4;

        Ball { velocity, ..*self }
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
    velocity: Vec2,
    color:  Rgb<Srgb, u8>,
}
