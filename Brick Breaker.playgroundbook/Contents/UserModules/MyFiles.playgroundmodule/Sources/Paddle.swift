import Foundation

/// /*#-localizable-zone(usermodulePaddle1)*/A paddle in the Brick Breaker game. It moves from side to side to control the ball./*#-end-localizable-zone*/
public class Paddle: Sprite {
    
    var collisionSound: GameSound = .warpMono
    
    /// /*#-localizable-zone(usermodulePaddle2)*/Allows you to move the paddle back and forth with your touch./*#-end-localizable-zone*/
    public func enableHorizontalTracking(in scene: Scene) {
        scene.trackTouch(withSprite: self)
    }
    
    /// /*#-localizable-zone(usermodulePaddle3)*/Disables touch control of the paddle./*#-end-localizable-zone*/
    public func disableHorizontalTracking(in scene: Scene) {
        scene.stopTrackingTouch(withSprite: self)
    }
        
    /// /*#-localizable-zone(usermodulePaddle4)*/Sets up the paddle by giving it initial values./*#-end-localizable-zone*/
    public init(image: Image) {
        super.init(graphicType: .sprite, name: "paddle")
        self.image = image
        xScale = 1.25
        friction = 0.1
        interactionCategory = .paddle
        collisionCategories = [.ball]
        collisionNotificationCategories =  [.ball]
        
        setOnCollisionHandler { collision in
            let position = collision.spriteB.position
            self.playCollisionSound(self.collisionSound, at: position, using: self.collisionSoundSource)
        }
        disablesOnDisconnect = true
    }
    
    var collisionSoundSource = Graphic(shape: .circle(radius: 4), color: .clear, name: "impact")
}
