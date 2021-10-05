use nokhwa::{Camera, CameraFormat, FrameFormat};

fn main() {
    // set up the Camera
    let mut camera = Camera::new(
        0, // index
        Some(CameraFormat::new_from(640, 480, FrameFormat::MJPEG, 30)), // format
    )
    .unwrap();
    // open stream
    camera.open_stream().unwrap();
    loop {
        let frame = camera.frame().unwrap();
        println!("{}, {}", frame.width(), frame.height());
    }
}