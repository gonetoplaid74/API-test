import Foundation

extension GameLevel {
    /// /*#-localizable-zone(levelExtension1)*/Removes any rewards from the scene./*#-end-localizable-zone*/
    func removeReward() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            scene.removeGraphics(named: "reward")
        }
    }
    
    /// /*#-localizable-zone(levelExtension2)*/Removes a ball from the scene./*#-end-localizable-zone*/
    func removeBall(_ sprite: Sprite) {
        if let ball = sprite as? Ball {
            balls.removeAll(where: { $0 == ball })
            sprite.remove()
        }
    }
    
    /// /*#-localizable-zone(levelExtension3)*/Monitors the ball’s motion./*#-end-localizable-zone*/
    public func monitorBall() {
        scene.setOnCollisionHandler { collision in
            if let ball = collision.spriteA as? Ball {
                self.checkBall(ball: ball)
            }
            
            if let ball = collision.spriteB as? Ball {
                self.checkBall(ball: ball)
            }
            
            if collision.isOverlapping {
                if let ball = collision.spriteA as? Ball, ball.interactionCategory == .oddBall, let brick = collision.spriteB as? Brick {
                    brick.explode()
                } else if let ball = collision.spriteB as? Ball, ball.interactionCategory == .oddBall, let brick = collision.spriteA as? Brick {
                    brick.explode()
                }
            }
        }
    }
    
    /// /*#-localizable-zone(levelExtension4)*/Updates the ball with the appropriate speed and direction./*#-end-localizable-zone*/
    func checkBall(ball: Ball) {
        let velocity = ball.velocity
        let speed = (velocity.dx * velocity.dx) + (velocity.dy * velocity.dy)
        let linearSpeed = (sqrt(speed))
        
        // /*#-localizable-zone(usermodulecomments9)*/Slow down the ball if it’s too fast./*#-end-localizable-zone*/
        if linearSpeed > 2800 {
            ball.velocity = Vector(dx: velocity.dx * 0.85, dy: velocity.dy * 0.85)
        }
        
        // /*#-localizable-zone(usermodulecomments10)*/Speed up the ball if it’s too slow./*#-end-localizable-zone*/
        if (linearSpeed < 350) && (linearSpeed > 0) {
            let scale = 350 / linearSpeed
            ball.velocity = Vector(dx: velocity.dx * scale,
                                   dy: velocity.dy * scale)
        }
        
        // /*#-localizable-zone(usermodulecomments11)*/Increase the y angle if it’s too sharp./*#-end-localizable-zone*/
        if (velocity.dy > 0.0) && (velocity.dy < velocity.dx / 8.0) {
            ball.velocity = Vector(dx: ball.velocity.dx,
                                   dy: velocity.dx / 4.0)
        }
        if (velocity.dy < 0.0) && (velocity.dy > -(velocity.dx / 8.0)) {
            ball.velocity = Vector(dx: ball.velocity.dx,
                                   dy: -(velocity.dx / 4.0))
        }
    }
    
    /// /*#-localizable-zone(levelExtension5)*/Adds walls to the level./*#-end-localizable-zone*/
    func addWalls() {
        let bounciness = 1.00 + (0.0125 * difficulty)
        let wallImage: Image = #imageLiteral(resourceName: "WallTile@2x.png")
        
        let leftWall = Wall(image: wallImage, orientation: .vertical)
        scene.place(leftWall, at: Point(x: -537, y: 0))
        leftWall.bounciness = bounciness
        scene.place(leftWall.collisionSoundSource, at: leftWall.position)
        leftWall.collisionSound = .blipMono
        
        let rightWall = Wall(image: wallImage, orientation: .vertical)
        scene.place(rightWall, at: Point(x: 537, y: 0))
        rightWall.bounciness = bounciness
        scene.place(rightWall.collisionSoundSource, at: rightWall.position)
        rightWall.collisionSound = .blipMonoRight

        let topWall = Wall(image: wallImage, orientation: .horizontal)
        scene.place(topWall, at: Point(x: 0, y: 539))
        topWall.bounciness = bounciness
        scene.place(topWall.collisionSoundSource, at: topWall.position)
        topWall.collisionSound = .blipMonoMiddle
    }
    
    /// /*#-localizable-zone(levelExtension6)*/Adds bricks to the level using the level’s layout and brickMaker function./*#-end-localizable-zone*/
    public func addBricks(layout: Layout, brickMaker: ((Color) -> Brick)) {
        let sceneSize = Size(width: 1000, height: 1000)
        let layoutSize = Size(width: sceneSize.width, height: sceneSize.height * 0.4)
        let padding = 0.95
        let brickSize = Size(width: layoutSize.width / Double(layout.columns), height: layoutSize.height / Double(layout.rows))
        let sampleBrick = Brick(tint: .red)
        guard let image = sampleBrick.image else { return }
        let xScale = Double(10.0 / image.size.width)
        let yScale = Double(10.0 / image.size.height)
        let startPosition = Point(x: -(layoutSize.width / 2.0) - (brickSize.width / 2.0), y: (sceneSize.height / 2.0) - (brickSize.height / 2.0))
        
        var position = startPosition
        
        for rowColors in layout.colors {
            position.x = startPosition.x
            for color in rowColors {
                position.x += brickSize.width
                if color.alpha < 0.01 { continue }
                let brick = brickMaker(color)
                brick.addOnExplodeHandler(handler: checkForLevelCompletion)
                brick.bounciness = 1.00
                brick.xScale = xScale * brickSize.width / 10.0 * padding
                brick.yScale = yScale * brickSize.height / 10.0 * padding
                scene.place(brick, at: position)
                
                brickCount += 1
            }
            position.y -= brickSize.height
        }
    }
    
    /// /*#-localizable-zone(levelExtension7)*/Clears all game elements, except rewards, from the level./*#-end-localizable-zone*/
    func clearLevel() {
        paddle.disableHorizontalTracking(in: scene)
        paddle.remove()
        scene.removeGraphics(named: "ball")
        scene.removeGraphics(named: "brick")
        scene.removeGraphics(named: "wall")
        scene.removeGraphics(named: "impact")
    }
    
    /// /*#-localizable-zone(levelExtension8)*/Starts the ball from the paddle./*#-end-localizable-zone*/
    func startBall(_ ball: Ball) {
        playSound(.crystal)
        let x = paddle.position.x
        var yOffset = (paddle.size.height / 2.0) + ((ball.size.height / 2.0))
        if paddle.image == #imageLiteral(resourceName: "Paddle_1@2x.png") {
            yOffset = (paddle.size.height / 5.0) + ((ball.size.height / 2.0))
        }
        scene.place(ball, relativeTo: paddle, xOffset: 0.0, yOffset: yOffset)

        // /*#-localizable-zone(levelExtensionWeld)*/Add a weld joint./*#-end-localizable-zone*/
        let weld = Joint.fixed(from: paddle, to: ball, at: Point(x: x, y: paddle.position.y + (paddle.size.height / 2.0)))
        scene.add(joint: weld)
        paddle.disableHorizontalTracking(in: scene)
        paddle.setVelocity(x: 0, y: 0)
        
        // /*#-localizable-zone(levelExtensionCountDown)*/Count down to start./*#-end-localizable-zone*/
        scene.countDown() {
            playSound(.retroJump2)
            scene.remove(joint: weld)
            self.paddle.enableHorizontalTracking(in: scene)
            ball.setVelocity(x: 0, y: (400) + (self.difficulty * 50))
        }
    }
    
    /// /*#-localizable-zone(levelExtensionaddAccessibility)*/Adds accessibility information to the game elements./*#-end-localizable-zone*/
    func addAccessibility() {
        paddle.addAccessibility()
        let walls = scene.getPlacedGraphics(named: "wall")
        for wall in walls {
            if wall.position.x == 0 && wall.position.y > 0 {
                wall.addAccessibility(usingKey: "top-wall")
            } else if wall.position.x < 0 && wall.position.y == 0 {
                wall.addAccessibility(usingKey: "left-wall")
            } else if wall.position.x > 0 && wall.position.y == 0 {
                wall.addAccessibility(usingKey: "right-wall")
            } else if wall.position.x == 0 && wall.position.y < 0 {
                wall.addAccessibility(usingKey: "foul-line")
            }
        }
        let bricks = scene.getPlacedGraphics(named: "brick")
        for brick in bricks {
            brick.addAccessibility()
        }
    }
}

public extension Sprite {
    /// /*#-localizable-zone(levelExtension17)*/Causes the graphic to shoot out sparks./*#-end-localizable-zone*/
    func spark(duration: Double, color: Color) {
        SceneProxy().addParticleEmitter(id: id, name: "Spark", duration: duration, color: color)
    }
    
    /// /*#-localizable-zone(levelExtension18)*/Creates an explosion animation on the graphic./*#-end-localizable-zone*/
    func explode(color: Color) {
        SceneProxy().addParticleEmitter(id: id, name: "Explode", duration: 2, color: color)
    }
    
    /// /*#-localizable-zone(levelExtension19)*/Tiny orbs of light dance around the graphic./*#-end-localizable-zone*/
    func sparkle(duration: Double, color: Color) {
        SceneProxy().addParticleEmitter(id: id, name: "Sparkles", duration: duration, color: color)
    }
    
    /// /*#-localizable-zone(levelExtension50)*/A tracer image follows the graphic./*#-end-localizable-zone*/
    func tracer(duration: Double, color: Color) {
        SceneProxy().addParticleEmitter(id: id, name: "Tracer", duration: duration, color: color)
    }
}

public extension Label {
    /// /*#-localizable-zone(levelExtensionLabelSparkle)*/Tiny orbs of light dance around the label./*#-end-localizable-zone*/
    func sparkle(duration: Double, color: Color) {
        SceneProxy().addParticleEmitter(id: id, name: "Sparkles", duration: duration, color: color)
    }
}

public extension Scene {
    /// /*#-localizable-zone(levelExtension20)*/Confetti rains from the sky./*#-end-localizable-zone*/
    func confetti(duration: Double, color: Color = Color.clear) {
        SceneProxy().addParticleEmitter(id: "scene", name: "Confetti", duration: duration, color: color)
    }
    
    /// /*#-localizable-zone(levelExtension21)*/Colored orbs fill the scene./*#-end-localizable-zone*/
    func orbs(duration: Double, color: Color = Color.clear) {
        SceneProxy().addParticleEmitter(id: "scene", name: "Orbs", duration: duration, color: color)
    }
    
    /// /*#-localizable-zone(levelExtension22)*/Bubbles percolate from the bottom of the scene./*#-end-localizable-zone*/
    func bubbles(duration: Double, color: Color = Color.clear) {
        SceneProxy().addParticleEmitter(id: "scene", name: "Bubbles", duration: duration, color: color)
    }
    
    /// /*#-localizable-zone(levelExtension23)*/Rain falls on the scene./*#-end-localizable-zone*/
    func rain(duration: Double, color: Color = Color.clear) {
        SceneProxy().addParticleEmitter(id: "scene", name: "Rain", duration: duration, color: color)
    }
    
    /// /*#-localizable-zone(levelExtension24)*/Clouds move across the scene./*#-end-localizable-zone*/
    func clouds(duration: Double, color: Color = Color.clear) {
        SceneProxy().addParticleEmitter(id: "scene", name: "Clouds", duration: duration, color: color)
    }
}
