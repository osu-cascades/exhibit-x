use freenectrs::freenect::{FreenectContext, FreenectDepthFormat, FreenectDepthStream, FreenectDevice, FreenectResolution, FreenectVideoFormat, FreenectVideoStream};
pub struct Kinect<'a, 'b: 'a> {
    ctx: &'a FreenectContext,
    device: &'a FreenectDevice<'a, 'b>,
    pub dstream: FreenectDepthStream<'a, 'b>,
    pub vstream: FreenectVideoStream<'a, 'b>,
}

impl<'a, 'b> Kinect<'a, 'b> {
    pub fn new() -> Kinect<'a, 'b> {
        let ctx = Box::new(FreenectContext::init_with_video_motor().unwrap());
        let ctx = Box::leak(ctx);

        let device = Box::new(ctx.open_device(0).unwrap());
        let device = Box::leak(device);

        device
            .set_depth_mode(
                FreenectResolution::Medium,
                FreenectDepthFormat::Bit11,
            )
            .unwrap();
        device
            .set_video_mode(
                FreenectResolution::Medium,
                FreenectVideoFormat::Rgb,
            )
            .unwrap();
        let dstream = device.depth_stream().unwrap();
        let vstream = device.video_stream().unwrap();

        Kinect {ctx, device, dstream, vstream}
    }
}