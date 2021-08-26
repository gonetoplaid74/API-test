/// /*#-localizable-zone(usermoduleWall1)*/A wall in the Brick Breaker game. You use walls to form the borders of the game./*#-end-localizable-zone*/
public class Wall: Sprite {
        
    var collisionSound: GameSound = .blipMono
    
    /// /*#-localizable-zone(usermoduleWall2)*/Creates a wall and sets its initial values./*#-end-localizable-zone*/
    public init(image: Image, orientation: WallOrientation) {
        super.init(graphicType: .sprite, name: "wall")
        
        suppressMessageSending = true
        self.image = image
        suppressMessageSending = false
        
        setTiledImage(image: image, columns: 20, rows: 1, isDynamic: false)
        
        if orientation == .vertical {
            rotation = 90
        }
        
        bounciness = 1.01
        isDynamic = false
        scale = 1.8
        interactionCategory = .wall
        collisionCategories = [.ball, .oddBall]
        collisionNotificationCategories = [.ball, .oddBall]
                
        setOnCollisionHandler { collision in
            let position = collision.spriteB.position
            self.playCollisionSound(self.collisionSound, at: position, using: self.collisionSoundSource)
        }
    }
    
    var collisionSoundSource = Graphic(shape: .circle(radius: 4), color: .clear, name: "impact")
}

/// /*#-localizable-zone(usermoduleWall3)*/The options for wall orientation: vertical or horizontal./*#-end-localizable-zone*/
public enum WallOrientation {
    case horizontal
    case vertical
}
