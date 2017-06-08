#include "Bubble.h"

Bubble::Bubble() {
    x = ofRandom(100, ofGetWidth() - 100),
    y =     ofRandom(10, 50),
    r = ofRandom(10, 50);
    v = ofRandom(0, -10);
    color = ofColor(ofRandom(150, 255), ofRandom(150, 255), ofRandom(150, 255), 130);
}

Bubble::Bubble(float x, float y, float r, float v) {
    this->x = x;
    this->y = y;
    this->r = r;
    this->v = v;
}

void Bubble::move() {
    y += v;
    v += ACCELERATION;
    if (y + r >= ofGetHeight()) {
        v *= -DAMPING;
        y = ofGetHeight() - r;
    }
}

void Bubble::draw() {
    ofSetColor(color);
    ofDrawCircle(x, y, r);
}
