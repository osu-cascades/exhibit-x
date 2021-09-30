use nannou::prelude::*;

fn main() {
    nannou::app(model).update(update).run();
}

struct Model {
    _window: window::Id,
    ball: Ball,
}

#[derive(Copy, Clone)]
struct Point {
    x: f32,
    y: f32,
}

struct Ball {
    position: Point,
    velocity: Point,
}

impl Ball {
    fn update(&self, boundary: Rect) -> Ball {
        self.update_velocity(boundary).update_position()
    }

    fn update_velocity(&self, boundary: Rect) -> Ball {
        let Ball{ position, velocity } = self;
        let mut velocity = velocity.clone();

        if position.x < boundary.left() || position.x > boundary.right() {
            velocity.x *= -1.0; 
        }

        if position.y < boundary.bottom() || position.y > boundary.top() {
            velocity.y *= -1.0; 
        }

        Ball { position: *position, velocity }
    }

    fn update_position(&self) -> Ball {
        let Ball{ position, velocity } = self;
        let position = Point {
            x: position.x + velocity.x,
            y: position.y + velocity.y,
        };

        Ball {position, velocity: *velocity}
    }

    fn draw(&self, draw: &Draw) {
        let Ball{ position, .. } = self;
        let Point{ x, y } = position;

        draw.ellipse().color(STEELBLUE).x_y(*x, *y);
    }
}

fn model(app: &App) -> Model {
    let ball = Ball {
        position: Point { x: 0.0, y: 0.0 },
        velocity: Point { x: 1.0, y: -10.0 }, 
    };
    let _window = app.new_window().view(view).build().unwrap();
    Model { ball, _window }
}

fn update(app: &App, model: &mut Model, _update: Update) {
    model.ball = model.ball.update(app.window_rect());
}

fn view(app: &App, model: &Model, frame: Frame) {
    let draw = app.draw();
    let Model{ ball, .. } = model;

    ball.draw(&draw);
    draw.background().color(PLUM);
    draw.to_frame(app, &frame).unwrap();
}
