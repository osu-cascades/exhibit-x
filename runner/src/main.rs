use sketch::Sketch;
use std::{path::PathBuf, thread, time::Duration};

mod sketch;

fn main() {
    let sketches = vec![
        Sketch::new(
            "trippy_colors".to_string(),
            PathBuf::from("/home/exhibitx/ExhibitX/exhibit-x/finshedSketches/trippy_colors"),
        ),
        Sketch::new(
            "face".to_string(),
            PathBuf::from("/home/exhibitx/ExhibitX/exhibit-x/finshedSketches/face"),
        ),
    ];

    loop {
        for sketch in &sketches {
            println!("Running {}", sketch);
            sketch.spawn();
            thread::sleep(Duration::from_secs(60));
            Sketch::kill_all();
        }
    }
}
