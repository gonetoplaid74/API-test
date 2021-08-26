/// /*#-localizable-zone(usermodule28)*/A level of the Brick Breaker game./*#-end-localizable-zone*/
public class Level: GameLevel {
    
    // /*#-localizable-zone(usermodule29)*/The variables for the level./*#-end-localizable-zone*/
    public var paddle : Paddle
    public var balls : [Ball] = []
    public var ballImage : Image = #imageLiteral(resourceName: "Ball_1@2x.png")
    public var paddleImage : Image = #imageLiteral(resourceName: "Paddle_6@2x.png")
    public var difficulty : Double = 3
    public var brickCount : Int = 0
    // /*#-localizable-zone(usermodulecomments50)*/Completion handler./*#-end-localizable-zone*/
    
    
    var layout: Layout
    // /*#-localizable-zone(usermodulecomments00)*/Add lives./*#-end-localizable-zone*/

    
    /// /*#-localizable-zone(usermodule34)*/Creates a level and sets its initial values./*#-end-localizable-zone*/
    public init(using layout: Layout = Layout.plain()) {
        scene.hasCollisionBorder = true
        scene.backgroundImage = #imageLiteral(resourceName: "Background_1.png")
        paddle = Paddle(image: paddleImage)
        self.layout = layout
    }
    
    /// /*#-localizable-zone(usermodule35)*/Adds all of the game elements and runs the level./*#-end-localizable-zone*/
    public func run() {
        // /*#-localizable-zone(usermodulecomments4)*/Add a paddle./*#-end-localizable-zone*/
        
        
        // /*#-localizable-zone(usermodulecomments5)*/Add a ball and give it a velocity./*#-end-localizable-zone*/
        
        
        // /*#-localizable-zone(usermodulecomments6)*/Add a brick layout./*#-end-localizable-zone*/
        
        
        // /*#-localizable-zone(usermodulecomments7)*/Add walls and a foul line./*#-end-localizable-zone*/
        addWalls()

        
        // /*#-localizable-zone(leveladdAccessibility)*/Add accessibility information./*#-end-localizable-zone*/
        addAccessibility()
    }
    
    /// /*#-localizable-zone(usermodule36)*/Creates a brick using a color./*#-end-localizable-zone*/
    public func createBrick(color: Color) -> Brick {
        let brick = Brick(tint: color)
        
        // /*#-localizable-zone(usermodulecomments8)*/Brick customizations./*#-end-localizable-zone*/
        
        
        
        return brick
    }
    
    
    /// /*#-localizable-zone(usermodule37)*/Called any time a brick breaks. Checks if the level is complete./*#-end-localizable-zone*/ 
    public func checkForLevelCompletion() {
        
        
        
    }
    
    /// /*#-localizable-zone(usermodule38)*/Called after you win the level./*#-end-localizable-zone*/
    public func winLevel() {
        let reward = Label(text: "🥳", color: #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: 225, name: "reward")
        scene.place(reward, at: Point(x: 0, y: 0))
        clearLevel()
        
       
    }
    
    /// /*#-localizable-zone(usermodule39)*/Called when the ball hits the foul line./*#-end-localizable-zone*/
    func hitFoulLine(sprite: Sprite) {
        
       
        
        
    }
    
    
    /// /*#-localizable-zone(usermodule40)*/Called when you lose the level./*#-end-localizable-zone*/
    public func loseLevel() {
        let failure = Label(text: "😭", color: #colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: 200)
        scene.place(failure, at: Point(x: 0, y: 0))
        clearLevel()
        
        
        
    }
    
    /// /*#-localizable-zone(usermodule41)*/Adds a foul line to remove balls when hit./*#-end-localizable-zone*/
   func addFoulLine() {
        let foulLine = Wall(image: #imageLiteral(resourceName: "FoulTile@2x.png"), orientation: .horizontal)
        foulLine.scale = 1
        scene.place(foulLine, at: Point(x: 0, y: -500))
        
        foulLine.setOnCollisionHandler { collision in
            
            if collision.spriteB.name == "ball" {
                self.hitFoulLine(sprite: collision.spriteB)
            }
        }
    }
    
    /// /*#-localizable-zone(usermodule42)*/Adds a paddle and sets its values./*#-end-localizable-zone*/
    func addPaddle() {
        paddle = Paddle(image: paddleImage)
        paddle.bounciness = 1.05 + (0.02 * difficulty)
        scene.place(paddle, at: Point(x: 0, y: -300))
        paddle.enableHorizontalTracking(in: scene)
        scene.place(paddle.collisionSoundSource, at: paddle.position)
    }
    
    /// /*#-localizable-zone(usermodule43)*/Creates a ball and adds it to the balls array./*#-end-localizable-zone*/
    public func addBall(at point: Point = Point.zero) -> Ball {
        let ball = Ball(image: ballImage)
        scene.place(ball, at: point)
        balls.append(ball)
        
        monitorBall()
        
        return ball
    }
}
