from paddle import Paddle

xDirection = 1
yDirection = 1

class Ball():
    def __init__(self, xPos, yPos):
        self.xPos = xPos
        self.yPos = yPos
        
    def move(self,screenWidth, screenHeight, players):
        global xDirection
        global yDirection
        speed = 2
        self.xPos = self.xPos - ( speed * xDirection )
        self.yPos = self.yPos - (speed * yDirection)
        if self.xPos > screenWidth or self.xPos < 0:
            xDirection *= -1
        if self.yPos > screenHeight or self.yPos < 0:
            yDirection *= -1 
            
        for player in players:
            
            if ((player.yPos - 100) <= self.yPos <= (player.yPos + 100)) and ((player.xPos - 5)  <= self.xPos <= (player.xPos + 5)):
                xDirection *= -1

        
    def draw(self):
        fill(247, 0, 0)
        ellipse(self.xPos, self.yPos, 25, 25)
        fill(255, 255, 255)