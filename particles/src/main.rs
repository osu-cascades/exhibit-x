mod balls;
mod ball;
mod person;

use nannou::prelude::*;
use balls::Balls;
use person::Person;

fn main() {
    nannou::app(init_model).update(update).run();
}

struct Model {
    _window: window::Id,
    balls: Balls,
    person: Person,
}

impl Model {
    fn reset(&mut self) {
        self.balls = init_balls();         
    }
}

fn init_model(app: &App) -> Model {
    let balls = init_balls();
    let person = Person::new(vec![Point2::new(-50.0,-100.0), Point2::new(50.0,-100.0), Point2::new(50.0,-50.0), Point2::new(0.0,0.0)]);
    let _window = app.new_window().view(view).build().unwrap();
    Model { balls, person, _window }
}

fn init_balls() -> Balls {
    Balls::new(10, 5.0)
}

fn update(app: &App, model: &mut Model, _update: Update) {
    let Model { balls, person, .. } = model;
    model.balls = balls.update(app.window_rect(), person);
    if app.keys.down.contains(&Key::R){
        model.reset();
    }
}

fn view(app: &App, model: &Model, frame: Frame) {
    let draw = app.draw();
    let Model{ balls, person, .. } = model;

    balls.draw(&draw);
    person.draw(&draw);

    draw.background().color(BLACK);
    draw.to_frame(app, &frame).unwrap();
}
