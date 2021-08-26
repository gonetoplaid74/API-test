/// /*#-localizable-zone(usermodule16)*/Defines the requirements for a game level, such as a paddle property and a run function./*#-end-localizable-zone*/
public protocol GameLevel: class {
    var balls: [Ball] { get set }
    var paddle: Paddle { get set }
    var brickCount: Int { get set }
    var difficulty: Double { get set }
    var onCompletion: (() -> Void) { get set }

    func run()
    func clear()
    func addBall(at point: Point) -> Ball
    func createBrick(color: Color) -> Brick
    func checkForLevelCompletion()
    
    func winLevel()
    func loseLevel()
}

// /*#-localizable-zone(usermodulecomments3)*/Default implementations for GameLevel./*#-end-localizable-zone*/
extension GameLevel {
    
    public var onCompletion: (() -> Void) {
        get { return {} }
        set {}
    }
    
    public func run() {
        
    }
    
    public func checkForLevelCompletion() {
        
    }
    
    public func clear() {
        paddle.disableHorizontalTracking(in: scene)
        paddle.remove()
        scene.removeGraphics(named: "ball")
        scene.removeGraphics(named: "wall")
    }
    
    public func addBall(at point: Point = Point.zero) -> Ball {
        return Ball(image: #imageLiteral(resourceName: "vollyball@2x.png"))
    }
    
    public func createBrick(color: Color) -> Brick {
        return Brick(tint: .white)
    }
    
    public func winLevel() { }
    public func loseLevel() { }
}
