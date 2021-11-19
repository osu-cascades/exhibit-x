use std::{
    fmt::Display,
    path::PathBuf,
    process::{Child, Command, Stdio},
};

pub struct Sketch {
    name: String,
    path: PathBuf,
}

impl Sketch {
    pub fn new(name: String, path: PathBuf) -> Self {
        Self { name, path }
    }

    /// Kills all running processing sketches
    ///
    /// Individual sketches cannot be killed, so this method kills all sketches
    pub fn kill_all() {
        Command::new("killall")
            .arg("/home/exhibitx/.local/share/applications/processing-3.5.4/java/bin/java")
            .spawn()
            .unwrap();
    }

    fn path_str(&self) -> &str {
        // Lazy unwrapping is lazy
        self.path.to_str().unwrap()
    }

    pub fn spawn(&self) -> Child {
        Command::new("processing-java")
            .arg(format!("--sketch={}", self.path_str()))
            .arg("--present")
            .stdout(Stdio::null())
            .spawn()
            .unwrap()
    }
}

impl Display for Sketch {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}, located at {}",
            self.name,
            self.path.to_string_lossy()
        )
    }
}
