mod balls;
mod ball;

use nannou::prelude::*;
use balls::Balls;

fn main() {
    nannou::app(init_model).update(update).run();
}

struct Model {
    _window: window::Id,
    balls: Balls,
}

impl Model {
    fn reset(&mut self) {
        self.balls = init_balls();         
    }
}

fn init_model(app: &App) -> Model {
    let balls = init_balls();
    let _window = app.new_window().view(view).build().unwrap();
    Model { balls, _window }
}

fn init_balls() -> Balls {
    Balls::new(6, 15.0)
}

fn update(app: &App, model: &mut Model, _update: Update) {
    let Model { balls, .. } = model;
    model.balls = balls.update(app.window_rect());
    if app.keys.down.contains(&Key::R){
        model.reset();
    }
}

fn view(app: &App, model: &Model, frame: Frame) {
    let draw = app.draw();
    let Model{ balls, .. } = model;

    balls.draw(&draw);

    draw.background().color(BLACK);
    draw.to_frame(app, &frame).unwrap();
}
