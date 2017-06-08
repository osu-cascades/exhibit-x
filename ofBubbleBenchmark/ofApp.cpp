#include "ofApp.h"
#include "Bubble.h"
#include <vector>

const int NUMBER_OF_BUBBLES = 10;
vector<Bubble*> bubbles;

void ofApp::setup() {
    ofSetBackgroundColor(0);
    ofSetCircleResolution(20);
    for (int i = 0; i < NUMBER_OF_BUBBLES; ++i) {
        bubbles.push_back(new Bubble());
    }
}

void ofApp::update() {
    for (int i = 0; i < bubbles.size(); ++i) {
        bubbles.at(i)->move();
    }
}

void ofApp::draw() {
    for (int i = 0; i < bubbles.size(); ++i) {
        bubbles.at(i)->draw();
    }
    ofSetColor(255);
    ofDrawBitmapString("FPS: " + ofToString(ofGetFrameRate()), 10, 10);
}

void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
