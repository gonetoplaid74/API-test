private let knobName = "Finger Tracking Knob"
private let jointName = "Finger Tracking Joints"
import SpriteKit

public let scene = Scene()

extension Scene {
    
    public func trackTouch(withSprite sprite: Sprite) {
        // /*#-localizable-zone(sceneExtension1)*/Add a knob./*#-end-localizable-zone*/
        let knob = Sprite(shape: .circle(radius: 10), color: .clear, name: knobName)
        knob.isDynamic = false
        knob.interactionCategory = .knob
        knob.collisionCategories = []
        place(knob, at: sprite.position)
        
        let listenerGraphic = Graphic(shape: .circle(radius: 4), color: .clear)
        place(listenerGraphic, at: sprite.position)
        setPositionalAudioListener(listenerGraphic)

        // /*#-localizable-zone(sceneExtension2)*/Add a touch handler to the scene to move the knob./*#-end-localizable-zone*/
        
        var lastTouchOrNil: Point?
        
        setOnTouchMovedHandler { [unowned self](touch) in
            defer {lastTouchOrNil = touch.position}
            
            
            if touch.firstTouch && Scene.shouldUsePositionalAudio {
                sprite.addAudio(.paddleBassMono, positional: true, looping: true, volume: 40)
            } else if touch.lastTouch {
                sprite.removeAudio()
            }
            
            if touch.firstTouch { return }
            
            if let lastTouch = lastTouchOrNil {
                var motionVector = lastTouch.vector(to: touch.position)
                motionVector.dy = 0.0
                knob.position += motionVector
            }
        }
        
        // /*#-localizable-zone(sceneExtension3)*/Add a spring joint to make the paddle follow the knob./*#-end-localizable-zone*/
        
        let spring = Joint.spring(name: jointName,
                                  from: sprite,
                                  at: sprite.position,
                                  to: knob,
                                  at: sprite.position)
        
        spring.damping = 0.95
        spring.frequency = 5.0
        
        add(joint: spring)
        
        // /*#-localizable-zone(sceneExtension4)*/Add a slide joint so that the paddle can only move horizontally./*#-end-localizable-zone*/
        
        let slide = Joint.sliding(name: jointName,
                                  from: sprite,
                                  at: sprite.position,
                                  axis: Vector(dx: 1.0, dy: 00))
        slide.shouldEnableLimits = true
        slide.minimumDistanceLimit = -500
        slide.maximumDistanceLimit = 500
        
        add(joint: slide)
    }
    
    func stopTrackingTouch(withSprite: Sprite) {
        setOnTouchMovedHandler(nil)
        removeGraphics(named: knobName)
        removeJoints(named: jointName)
    }
    
    static var shouldUsePositionalAudio: Bool {
        return Scene.isVoiceOverRunning
    }
}

public extension Graphic {
    /// /*#-localizable-zone(graphicBounce)*/Moves the graphic up and down, simulating a bouncing effect./*#-end-localizable-zone*/
    func bounce() {
        var distance: CGFloat = 100
        var actions: [SKAction] = []
        
        for _ in 1...9 {
            distance -= 8
            let up = SKAction.moveBy(x: 0, y: distance, duration: TimeInterval(0.002 * distance))
            up.timingMode = .easeOut
            let down = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.0020 * distance))
            down.timingMode = .easeIn
            actions.append(up)
            actions.append(down)
        }
        
        let jumpSequence = SKAction.sequence(actions)
        self.run(jumpSequence)
    }
    
    /// /*#-localizable-zone(graphicAddAudio)*/Adds a sound to the graphic./*#-end-localizable-zone*/
    func addAudio(_ sound: GameSound, positional: Bool = true, looping: Bool = true, volume: Double = 100) {
        guard let fileName = sound.rawValue.url?.lastPathComponent else { return }
        addAudio(fileName, positional: positional, looping: looping, volume: volume)
    }
}

extension Sprite {
    
    /// /*#-localizable-zone(spritePlayCollisionSound)*/Plays a collision sound./*#-end-localizable-zone*/
    public func playCollisionSound(_ sound: GameSound, at position: Point, using soundSource: Graphic) {
        if Scene.shouldUsePositionalAudio {
            if !soundSource.hasAudio {
                soundSource.addAudio(sound, positional: true, looping: false, volume: 75)
            }
            soundSource.position = position
            soundSource.playAudio()
        } else {
            playSound(sound, volume: 75)
        }
    }
}
