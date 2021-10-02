use nannou::prelude::*;
use nannou::prelude::geom::Polygon;
use std::vec::IntoIter;

impl Person {
    pub fn new(points: Vec<Point2>) -> Person {
        Person { poly: Polygon::new(points) }
    }

    pub fn draw(&self, draw: &Draw){
        let Person { poly: Polygon { points } } = self;
        draw.polygon()
            .points(points.clone())
            .color(YELLOW);
    }

    pub fn contains(&self, point: Point2) -> bool{
        match self.poly.clone().contains(&point) {
            Some(_) => true,
            _ => false
        }
    }
}

pub struct Person {
    poly: Polygon<IntoIter<Point2>>
}