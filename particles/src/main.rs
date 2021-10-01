mod balls;
mod ball;

use nannou::prelude::*;
use balls::Balls;

fn main() {
    nannou::app(model).update(update).run();
}

struct Model {
    _window: window::Id,
    balls: Balls,
}

fn model(app: &App) -> Model {
    let balls = Balls::new(100, 5.0);
    let _window = app.new_window().view(view).build().unwrap();
    Model { balls, _window }
}

fn update(app: &App, model: &mut Model, _update: Update) {
    model.balls = model.balls.update(app.window_rect());
}

fn view(app: &App, model: &Model, frame: Frame) {
    let draw = app.draw();
    let Model{ balls, .. } = model;

    balls.draw(&draw);
    draw.background().color(BLACK);
    draw.to_frame(app, &frame).unwrap();
}
