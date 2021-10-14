use kinect::Kinect;
use nannou::prelude::*;

mod kinect;
const FRAME_WIDTH: usize = 640;
const WINDOW_HEIGHT: usize = 480;

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

    if let Ok((data, _timestamp)) = model.kinect.dstream.receiver.try_recv() {
        for (i, p) in data.iter().enumerate() {

            // let pixel_index = (i / FRAME_WIDTH * WINDOW_WIDTH) + (i % FRAME_WIDTH);
            let x = (i % FRAME_WIDTH ) as f32 - (FRAME_WIDTH / 2) as f32;
            let y = (i / FRAME_WIDTH ) as f32 - (WINDOW_HEIGHT / 2) as f32;
            // println!("x={}, y={}", x, y);

            // Threshold depth data
            if *p < 1000 && *p > 950 {
                // println!("x={}, y={}", x, y);
                draw.rect()
                .color(PINK)
                .x_y(x, y)
                .width(1.0)
                .height(1.0);
            }
            
            // let p_normalized = (p.clone() as f64) / 2048.0;
            // let pc = ((1.0 - p_normalized) * 255.0) as u32;
            // let pixel_val = pc | pc << 8 | pc << 16;
        }
    }       

    draw.to_frame(app, &frame).unwrap();
}

struct Model<'a, 'b> {
    _window: window::Id,
    kinect: Kinect<'a, 'b>
} 