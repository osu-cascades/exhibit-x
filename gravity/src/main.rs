mod balls;
mod ball;
mod person;
mod physics;

use nannou::prelude::*;
use balls::Balls;
use person::Person;
use physics::{Massive, apply_gravity};

use crate::physics::Attractor;

pub trait Drawable {
    fn draw(&self, draw_context: &Draw);
}

fn main() {
    nannou::app(init_model).update(update).run();
}

struct Model {
    _window: window::Id,
    balls: Balls,
    person: Person
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
    Model { person, balls, _window }
}

fn init_balls() -> Balls {
    // Balls::new(10, 20.0)
    Balls::new_static()
}

fn update(app: &App, model: &mut Model, _update: Update) {
    let Model { balls, person, .. } = model;

    apply_gravity(balls.balls_mut());
    
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
