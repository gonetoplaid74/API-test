import Foundation

/// /*#-localizable-zone(usermodule4)*/A brick in the Brick Breaker game./*#-end-localizable-zone*/
public class Brick: Sprite {
    
    /// /*#-localizable-zone(usermodule5)*/The number of times the brick can be hit before it breaks./*#-end-localizable-zone*/
    public var strength = 1
    
    /// /*#-localizable-zone(usermodule6)*/Creates a brick and sets its initial values./*#-end-localizable-zone*/
    public init(tint: Color) {
        let image: Image = #imageLiteral(resourceName: "Brick_3@2x.png")
        super.init(graphicType: .sprite, name: "brick")
        self.image = image
        setTintColor(tint, blend:1.0)
        xScale = Double(120.0 / image.size.width)
        yScale = Double(30.0 / image.size.height)
        isDynamic = false
        bounciness = 1.0
        disablesOnDisconnect = true
        // /*#-localizable-zone(usermodulecomments1)*/Only send collision events when a ball hits a brick./*#-end-localizable-zone*/
        collisionNotificationCategories = [.ball, .oddBall]
        interactionCategory = .brick
        collisionCategories = [.brick, .ball]
        
        var startingStrength = strength
        var firstHit = true
        
        addOnExplodeHandler {
            self.explode(color: Color.white)
        }
        
        // /*#-localizable-zone(usermodulecomments2)*/Called when a brick gets hit by a ball./*#-end-localizable-zone*/
        onCollisionHandler = { collision in
            playSound(.pop)
            if firstHit {
                startingStrength = self.strength
                firstHit = false
            }
            self.alpha -= Double(1.0 / Double(startingStrength))
            self.strength -= 1

            if self.strength == 0 {
                self.explode()
            }
        }
    }
    
    /// /*#-localizable-zone(usermodule6b)*/Explodes the brick./*#-end-localizable-zone*/
    public func explode() {
        for handler in self.onExplode {
            handler()
        }
        remove()
    }
    
    /// /*#-localizable-zone(usermodule7)*/If true, allows a ball to pass through the brick./*#-end-localizable-zone*/
    public var ballPassesThrough = false {
        didSet {
            if ballPassesThrough {
                interactionCategory = .oddBrick
                collisionCategories = .inactive
            } else {
                interactionCategory = .brick
                collisionCategories = [.ball, .oddBall]
            }
        }
    }
    
    var onExplode: [(() -> Void)] = [{}]
    
    /// /*#-localizable-zone(usermodule8)*/Adds a handler, which the brick calls when it explodes./*#-end-localizable-zone*/
    public func addOnExplodeHandler(handler: @escaping (() -> Void)) {
        onExplode.append(handler)
    }
}
