# Connecting the Kinect with Processing

Different versions of Kinect work different with Processing, need to figure out the version of the Kinect you have, 
and use the right version of Processing.

Version of Kinect we used: Version 1, 1414

This is the original kinect and works with the library documented on this page 
http://shiffman.net/p5/kinect/ in the Processing 3.0 beta series.

Version of Processing: Processing 3


# CANKinectPhysics

# Make sure to include the following libraries:

import org.openkinect.processing.*;

import blobDetection.*; // blobs

import toxi.geom.*; // toxiclibs shapes and vectors

import toxi.processing.*; // toxiclibs display

import shiffman.box2d.*; // shiffman's jbox2d helper library

import org.jbox2d.collision.shapes.*; // jbox2d

import org.jbox2d.dynamics.joints.*;

import org.jbox2d.common.*; // jbox2d

import org.jbox2d.dynamics.*; // jbox2d


# The code has many comments throughout, so feel free to copy the cody and change things as you desire.
# For some reason, though, there seems to be a framerate issue with Box2D and Kinect in Processing that we haven't been able to figure out. Feel free to debug it!

