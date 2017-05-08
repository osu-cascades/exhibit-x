from paddle import Paddle
from ball import Ball
player1 = Paddle(10, 100, 40, 320)
player2 = Paddle(10, 100, 600, 320)
newBall = Ball(300, 320)
keys = [False, False, False, False]
players = [player1, player2]
def setup():
    frameRate(60)
    size(640,640, P2D)
    background(0)
    
def draw():
    background(0)
    if keys[0] == True:
        player1.moveUp()
    if keys[1] == True:
        player1.moveDown()
    if keys[2] == True:
        player2.moveUp()
    if keys[3] == True:
        player2.moveDown()
    player1.draw()
    player2.draw()
    newBall.draw()
    newBall.move(width, height,players)
        
def keyPressed():
    if key == 'w':
        keys[0] = True
    if key == 's':
        keys[1] = True
    if key == 'r':
        keys[2] = True
    if key == 'f':
        keys[3] = True
def keyReleased():
    if key == 'w':
        keys[0] = False
    if key == 's':
        keys[1] = False
    if key == 'r':
        keys[2] = False
    if key == 'f':
        keys[3] = False
    
    
        
        
        