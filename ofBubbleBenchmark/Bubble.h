#pragma once
#include "ofMain.h"

class Bubble {
    public:
        float x;
        float y;
        float v;
        float r;
        float ACCELERATION = 5;
        float DAMPING = 0.8;
        ofColor color;
        
        Bubble();
        Bubble(float x, float y, float r, float v);
        void move();
        void draw();
};
