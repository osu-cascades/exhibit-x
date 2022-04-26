use sketch::Sketch;
use std::{fs, path::PathBuf, thread, time::Duration};

mod sketch;

fn main() {
    let tech_tri_base = "/home/exhibitx/ExhibitX/exhibit-x/TechTri/".to_string();

    let sketches = vec![
        Sketch::new(
            "ascii".to_string(),
            PathBuf::from(tech_tri_base.clone() + "ascii"),
        ),
        Sketch::new(
            "ball_rain".to_string(),
            PathBuf::from(tech_tri_base.clone() + "ball_rain"),
        ),
        Sketch::new(
            "box_man".to_string(),
            PathBuf::from(tech_tri_base.clone() + "box_man"),
        ),
        Sketch::new(
            "flowers".to_string(),
            PathBuf::from(tech_tri_base.clone() + "flowers"),
        ),
        Sketch::new(
            "processing_paint".to_string(),
            PathBuf::from(tech_tri_base.clone() + "processing_paint"),
        ),
        Sketch::new(
            "sketch_3d_image".to_string(),
            PathBuf::from(tech_tri_base.clone() + "sketch_3d_image"),
        ),
        Sketch::new(
            "thePast".to_string(),
            PathBuf::from(tech_tri_base.clone() + "thePast"),
        ),
        Sketch::new(
            "trippy_colors_full_scale".to_string(),
            PathBuf::from(tech_tri_base.clone() + "trippy_colors_full_scale"),
        ),
        Sketch::new(
            "trippy_zebra_better".to_string(),
            PathBuf::from(tech_tri_base.clone() + "trippy_zebra_better"),
        ),
        Sketch::new(
            "zebra".to_string(),
            PathBuf::from(tech_tri_base.clone() + "zebra"),
        ),
    ];

    loop {
        for sketch in &sketches {
            println!("Running {}", sketch);
            sketch.spawn();
            thread::sleep(Duration::from_secs(5));
            Sketch::kill_all();
        }
    }
}
