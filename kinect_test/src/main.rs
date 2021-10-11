use freenectrs::freenect;
const WINDOW_HEIGHT: usize = 480;

const FRAME_WIDTH: usize = 640;

fn main() {
    // Setup kinect
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

    // Get rgb and depth stream
    let dstream = device.depth_stream().unwrap();

    // Start kinect processing thread
    ctx.spawn_process_thread().unwrap();

    let mut buffer: Vec<u32> = vec![0; WINDOW_WIDTH * WINDOW_HEIGHT];

    let mut window = Window::new(
        "Kinect Test - ESC to exit",
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        WindowOptions::default(),
    )
    .unwrap_or_else(|e| {
        panic!("{}", e);
    });

    // Limit to max ~60 fps update rate
    window.limit_update_rate(Some(std::time::Duration::from_micros(16600)));

    while window.is_open() && !window.is_key_down(Key::Escape) {
        // Fetch the video and depth frames
        if let Ok((data, _timestamp)) = dstream.receiver.try_recv() {
            for (i, p) in data.iter().enumerate() {

                let pixel_index = (i / FRAME_WIDTH * WINDOW_WIDTH) + (i % FRAME_WIDTH);

                // Threshold depth data
                if *p > 900 || *p < 850 {
                    buffer[pixel_index] = 0;
                    continue;
                }

                let p_normalized = (p.clone() as f64) / 2048.0;
                let pc = ((1.0 - p_normalized) * 255.0) as u32;
                let pixel_val = pc | pc << 8 | pc << 16;
                
                buffer[pixel_index] = pixel_val;
            }

            //Display depth info at mouse cursor
            window
                .get_mouse_pos(MouseMode::Discard)
                .map(|(mouse_x, mouse_y)| {
                    for i in 0..buffer.len() {
                        let x = i % FRAME_WIDTH;
                        let y = i / FRAME_WIDTH;

                        if mouse_x as usize == x || mouse_y as usize == y {
                            buffer[i] = 0xFF << 18;
                        }
                    }

                    let index = mouse_x as usize + mouse_y as usize * FRAME_WIDTH;

                    if window.get_mouse_down(MouseButton::Left) {
                        println!("Depth at mouse cursor: {}", data[index]);
                    }
                });
        }

        window
            .update_with_buffer(&buffer, WINDOW_WIDTH, WINDOW_HEIGHT)
            .unwrap();
    }
    ctx.stop_process_thread().unwrap();
}
