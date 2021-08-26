/// /*#-localizable-zone(sampleLevel1)*/A level of the Brick Breaker game./*#-end-localizable-zone*/
public class SampleLevel: GameLevel {
    
    /// /*#-localizable-zone(sampleLevel2)*/The paddle used by the level./*#-end-localizable-zone*/
    public var paddle: Paddle
    
    /// /*#-localizable-zone(sampleLevel3)*/All of the balls currently in the level./*#-end-localizable-zone*/
    public var balls: [Ball] = []
    
    /// /*#-localizable-zone(sampleLevel4)*/The default image used for balls./*#-end-localizable-zone*/
    public var ballImage: Image = #imageLiteral(resourceName: "Ball_1@2x.png")
    
    /// /*#-localizable-zone(sampleLevel4b)*/The default image used for the paddle./*#-end-localizable-zone*/
    public var paddleImage: Image = #imageLiteral(resourceName: "Paddle_3@2x.png")

    /// /*#-localizable-zone(sampleLevel5)*/The difficulty of the level. Higher values are more difficult./*#-end-localizable-zone*/
    public var difficulty: Double = 3

    /// /*#-localizable-zone(sampleLevel6)*/The number of tries you have to beat the level./*#-end-localizable-zone*/
    public var lives = 3
    
    /// /*#-localizable-zone(sampleLevel7)*/Called after you win the level./*#-end-localizable-zone*/
    public var onCompletion: (() -> Void) = {}
    
    var layout: Layout
    public var brickCount: Int = 0
    
    /// /*#-localizable-zone(sampleLevel8)*/Creates a level and sets its initial values./*#-end-localizable-zone*/
    public init(using layout: Layout) {
        scene.hasCollisionBorder = true
        scene.backgroundImage = #imageLiteral(resourceName: "Background_1.png")
        paddle = Paddle(image: paddleImage)
        self.layout = layout
    }
    
    /// /*#-localizable-zone(sampleLevel9)*/Adds all game elements and runs the level./*#-end-localizable-zone*/
    public func run() {
        
        // /*#-localizable-zone(sampleLevelcomments1)*/Add a paddle./*#-end-localizable-zone*/
        addPaddle()
        
        // /*#-localizable-zone(sampleLevelcomments2)*/Add a ball and give it a velocity./*#-end-localizable-zone*/
        let ball = addBall()
        startBall(ball)
        
        // /*#-localizable-zone(sampleLevelcomments3)*/Add a brick layout./*#-end-localizable-zone*/
        addBricks(layout: layout, brickMaker: createBrick(color:))
        
        // /*#-localizable-zone(sampleLevelcomments4)*/Add walls and a foul line./*#-end-localizable-zone*/
        addFoulLine()
        addWalls()
        
        // /*#-localizable-zone(sampleLeveladdAccessibility)*/Add accessibility information./*#-end-localizable-zone*/
        addAccessibility()
    }
    
    /// /*#-localizable-zone(sampleLevel9b)*/Use a color from the layout to create a brick./*#-end-localizable-zone*/
    public func createBrick(color: Color) -> Brick {
        let brick = Brick(tint: color)
        
        if color ==  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) {
            brick.strength = 5
            brick.sparkle(duration: 300, color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
            brick.addOnExplodeHandler {
                for ball in self.balls {
                    ball.spark(duration: 3, color: #colorLiteral(red: 0.9254901960784314, green: 0.23529411764705882, blue: 0.10196078431372549, alpha: 1.0))
                    ball.setVelocity(x: ball.velocity.dx + 250, y: ball.velocity.dy + 250)
                    ball.passThroughBrick(duration: 3)
                }
            }
            
        }
        if color ==  #colorLiteral(red: 0.807843137254902, green: 0.027450980392156862, blue: 0.3333333333333333, alpha: 1.0) {
            brick.strength = 3
            brick.sparkle(duration: 300, color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
            brick.addOnExplodeHandler {
                let ball = self.addBall(at: brick.position)
                ball.setVelocity(x: -300, y: 500)
            }
        }
        
        if color ==  #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) {
            brick.strength = 4
            brick.isDynamic = true
            brick.allowsRotation = true
        }
        
        if color ==  #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) {
            brick.strength = 2
        }
        
        return brick
    }
    
    /// /*#-localizable-zone(sampleLevel10)*/Called any time a brick breaks. Checks if the level is complete./*#-end-localizable-zone*/
    public func checkForLevelCompletion() {
        brickCount -= 1
        if brickCount == 0 {
            winLevel()
        }
    }
    
    /// /*#-localizable-zone(sampleLevel11)*/Called once you win the level./*#-end-localizable-zone*/
    public func winLevel() {
        let reward = Label(text: "🥳", color: #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: 225, name: "reward")
        playSound(.powerUp3)
        scene.place(reward, at: Point(x: 0, y: 150))
        reward.bounce()
        scene.confetti(duration: 3)
        
        clearLevel()
        removeReward()
        onCompletion()
    }
    
    /// /*#-localizable-zone(sampleLevel12)*/Called when the ball hits the foul line./*#-end-localizable-zone*/
    func hitFoulLine(sprite: Sprite) {
         removeBall(sprite)
         
         if balls.count == 0 {
            lives -= 1
            
             if lives > 0 {
                 playSound(.radiant)
                 let ball = addBall()
                 startBall(ball)
                 let livesLeft = Label(text: "Lives = \(lives)", color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), font: .MarkerFelt, size: 75)
                 scene.place(livesLeft, at: Point(x: 0, y: -400))
                 livesLeft.fadeOut(after: 1)
             } else {
                 loseLevel()
             }
         }
     }
    
    /// /*#-localizable-zone(sampleLevel13)*/Called when you lose the level./*#-end-localizable-zone*/
    public func loseLevel() {
        let failure = Label(text: "😭", color: #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: 200)
        playSound(.electricBeepFader)
        scene.place(failure, at: Point(x: 0, y: 0))
        failure.shake(duration: 4)
        
        clearLevel()
    }
    
    /// /*#-localizable-zone(sampleLevel14)*/Adds a foul line to remove balls when hit./*#-end-localizable-zone*/
   func addFoulLine() {
        let foulLine = Wall(image: #imageLiteral(resourceName: "FoulTile@2x.png"), orientation: .horizontal)
        foulLine.scale = 1
        foulLine.setOnCollisionHandler { collision in
            
            if collision.spriteB.name == "ball" {
                self.hitFoulLine(sprite: collision.spriteB)
            }
        }
        scene.place(foulLine, at: Point(x: 0, y: -500))
    }
    
    /// /*#-localizable-zone(sampleLevel15)*/Adds a paddle and sets its values./*#-end-localizable-zone*/
    func addPaddle() {
        paddle = Paddle(image: paddleImage)
        paddle.bounciness = 1.05 + (0.02 * difficulty)
        scene.place(paddle, at: Point(x: 0, y: -300))
        paddle.enableHorizontalTracking(in: scene)
        scene.place(paddle.collisionSoundSource, at: paddle.position)
    }
    
    /// /*#-localizable-zone(sampleLevel16)*/Creates a ball and adds it to the balls array./*#-end-localizable-zone*/
    public func addBall(at point: Point = Point.zero) -> Ball {
        let ball = Ball(image: ballImage)
        scene.place(ball, at: point)
        balls.append(ball)
        
        monitorBall()

        return ball
    }
}

import Foundation
