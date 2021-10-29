trait Matter {
    fn mass() -> f64;
    fn gravitional_force(other_position: Point2, other_mass: Point2) -> f64;
}

impl Matter for Ball {
    
}