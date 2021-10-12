use kinect::Kinect;
use nannou::prelude::*;

mod kinect;

fn main(){
    nannou::app(init_model).update(update).run();
}

fn init_model<'a, 'b>(app: &App) -> Model<'a, 'b>{
    let kinect = Kinect::new();
    let _window = app.new_window().view(view).build().unwrap();

    Model { _window, kinect }
}

fn update(_app: &App, _model: &mut Model, _update: Update) {}

fn view(app: &App, model: &Model, frame: Frame) {
    let draw = app.draw();

    draw.background().color(BLACK);
    draw.to_frame(app, &frame).unwrap();
}

struct Model<'a, 'b> {
    _window: window::Id,
    kinect: Kinect<'a, 'b>
} 