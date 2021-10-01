mod ball;
mod point;

use nannou::prelude::*;
use ball::Ball;
use point::Point;

fn main() {
    nannou::app(model).update(update).run();
}

struct Model {
    _window: window::Id,
    ball: Ball,
}

fn model(app: &App) -> Model {
    let ball = Ball {
        position: Point { x: 0.0, y: 0.0 },
        velocity: Point { x: 1.0, y: -10.0 }, 
        radius: 20.0,
        color: STEELBLUE,
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
    draw.background().color(BLACK);
    draw.to_frame(app, &frame).unwrap();
}
