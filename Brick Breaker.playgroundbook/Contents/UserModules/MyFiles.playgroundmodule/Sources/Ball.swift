import Foundation

/// /*#-localizable-zone(usermodule1)*/A ball in the Brick Breaker game. A ball moves freely and bounces off bricks and paddles./*#-end-localizable-zone*/
public class Ball: Sprite {
    
    /// /*#-localizable-zone(usermodule2)*/Creates a ball and sets its initial values./*#-end-localizable-zone*/
    public init(image: Image) {
        super.init(graphicType: .sprite, name: "ball")
        self.image = image
        allowsRotation = true
        friction = 0.08
        drag = 0.0
        bounciness = 1.0
        scale = 1.5
        interactionCategory = .ball
        collisionCategories = [.paddle, .brick, .wall]
        collisionNotificationCategories = []
        disablesOnDisconnect = true
        addAccessibility()
    }
    
    /// /*#-localizable-zone(usermodule3)*/Allows a ball to pass through bricks./*#-end-localizable-zone*/
    public func passThroughBrick(duration: Double) {
        interactionCategory = .oddBall
        collisionCategories = [.paddle, .wall]
        
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) {_ in
            self.interactionCategory = .ball
            self.collisionCategories = [.paddle, .brick, .wall]
        }
    }
    
    func addAccessibility() {
        if Scene.shouldUsePositionalAudio {
            addAudio(.ballBeepsMono, positional: true, looping: true, volume: 10)
        }
        let axLabel = Graphic.accessibilityLabelFor(for: name)
        accessibilityHints = AccessibilityHints(makeAccessibilityElement: true, accessibilityLabel: axLabel)
    }
}
