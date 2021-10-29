use nannou::prelude::*;
use wgpu::Texture;

fn main() {
    nannou::app(model)
        .update(update)
        .simple_window(view)
        .run();
}

struct Model {
    canvas: Canvas
}

fn model(_app: &App) -> Model {
    Model {
        canvas: Canvas::new()
    }
}

fn update(_app: &App, _model: &mut Model, _update: Update) {
}

fn view(_app: &App, _model: &Model, frame: Frame){
    frame.clear(BLUE);
}

struct Canvas {
    data: Vec<u32>
}

impl Canvas {
    pub fn new() -> Self {
        Self {
            data: Vec::new(),
        }
    }

    pub fn contents_mut(&mut self) -> &mut Vec<u32> {
        &mut self.data
    }

    pub fn contents(&self) -> &Vec<u32> {
        &self.data
    }

    pub fn texture(&self) -> &Texture {
        Texture::from(&self.data)
    }
}