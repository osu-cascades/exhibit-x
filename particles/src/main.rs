mod balls;
mod ball;
mod person;

use nannou::prelude::*;
use balls::Balls;
use person::Person;

fn main() {
    nannou::app(model).update(update).run();
}

struct Model {
    _window: window::Id,
    balls: Balls,
    person: Person,
}

fn model(app: &App) -> Model {
    let balls = Balls::new(15, 5.0);
    let person = Person::new(vec![Point2::new(-50.0,-100.0), Point2::new(50.0,-100.0), Point2::new(50.0,-50.0)]);
    let _window = app.new_window().view(view).build().unwrap();
    Model { balls, person, _window }
}

fn update(app: &App, model: &mut Model, _update: Update) {
    let Model { balls, person, .. } = model;
    model.balls = balls.update(app.window_rect(), person);
}

fn view(app: &App, model: &Model, frame: Frame) {
    let draw = app.draw();
    let Model{ balls, person, .. } = model;

    balls.draw(&draw);
    person.draw(&draw);

    draw.background().color(BLACK);
    draw.to_frame(app, &frame).unwrap();
}
