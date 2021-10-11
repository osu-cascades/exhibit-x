use freenectrs::freenect;
use nannou::prelude::*;

fn main(){
    nannou::app(init_model).update(update).run();
}

fn init_model<'a>(app: &App) -> Model<'a>{
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

struct Model<'a> {
    _window: window::Id,
    kinect: Kinect<'a>
} 

struct Kinect<'a> {
    dstream: freenect::FreenectDepthStream<'a, 'a>,
    ctx: freenect::FreenectContext,
    device: freenect::FreenectDevice<'a, 'a>
}

impl<'a> Kinect<'a> {
    fn new() -> Kinect<'a> {
        let ctx = freenect::FreenectContext::init_with_video().unwrap();
        let device = ctx.open_device(0).unwrap();
        device
            .set_depth_mode(
                freenect::FreenectResolution::Medium,
                freenect::FreenectDepthFormat::Bit11,
            )
            .unwrap();
        device
            .set_video_mode(
                freenect::FreenectResolution::Medium,
                freenect::FreenectVideoFormat::Rgb,
            )
            .unwrap();
        let dstream = device.depth_stream().unwrap();

        Kinect {ctx, device, dstream}
    }
}