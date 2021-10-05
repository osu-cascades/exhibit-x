use nannou::prelude::*;
use nannou::prelude::geom::{Polygon};
use std::vec::IntoIter;
use itertools::Itertools;
use crate::ball::Ball;

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

    pub fn collition_angle(&self, ball: &Ball) -> Option<f32>{ // in radians 
        let nan_safe = Vec2::new(0.001, 0.001);
        ball.circumference()
            .find_map(|p| self.poly.clone().contains(&Point2::from_slice(&p)))
            .and_then(|tri| {
                match
                    tri.vertices()
                        .combinations(2)
                        .find(|v| lines_intersect(
                            [v[0], v[1]],
                            [ball.center(), tri.centroid()]))
                {
                    Some(v) => Some(
                        (v[1] + nan_safe)
                        .angle_between(v[0] + nan_safe)
                    ),
                    None => Some(PI/2.0)
                }
            })
    }
}

pub struct Person {
    poly: Polygon<IntoIter<Point2>>
}

fn lines_intersect(l1: [Point2; 2], l2: [Point2; 2]) -> bool {
   let dir1 = direction(l1[0], l1[1], l2[0]);
   let dir2 = direction(l1[0], l1[1], l2[1]);
   let dir3 = direction(l2[0], l2[1], l1[0]);
   let dir4 = direction(l2[0], l2[1], l1[1]);

    dir1 != dir2 && dir3 != dir4
}

// ideally a emun of the directions would be made, just an int for now works tho
fn direction(a: Point2, b: Point2, c: Point2) -> i8 {
    let val = (b.y-a.y)*(c.x-b.x)-(b.x-a.x)*(c.y-b.y);
    if val == 0.0 {
        0
    } else if val < 0.0 {
        1
    } else {
        2
    }
}