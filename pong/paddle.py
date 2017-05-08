speed = 3
class Paddle(object):
    def __init__(self, paddleWidth, paddleHeight, xPos, yPos): 
        self.paddleWidth = paddleWidth
        self.paddleHeight = paddleHeight
        self.xPos = xPos
        self.yPos = yPos
        
    def moveUp(self):
        self.yPos -= speed
    def moveDown(self):
        self.yPos += speed
        
    def draw(self):
        rect(self.xPos, self.yPos, self.paddleWidth, self.paddleHeight)
        