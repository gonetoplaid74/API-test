
import Foundation
import PlaygroundSupport
import SoundEffects
import MyFiles

public class CutSceneGame: Game {
    
    override public init() {
        super.init()
        lives = 1
    }
    
    override public func run() {
        showIntroScreen1()
    }
    
    private func showIntroScreen1() {
        playSound(.pop1, volume: 75)
        scene.createBackgroundUI(background1: #colorLiteral(red: 1, green: 0.577706039, blue: 0, alpha: 1),
                           background1Gradient: #colorLiteral(red: 0.708224237, green: 0.09132572263, blue: 0, alpha: 1),
                           background2: #colorLiteral(red: 1, green: 0.577706039, blue: 0, alpha: 1),
                           background2Gradient: #colorLiteral(red: 0.708224237, green: 0.09132572263, blue: 0, alpha: 1),
                           dots: #colorLiteral(red: 0.9706322863, green: 0.5613346901, blue: 0.008627369278, alpha: 1),
                           displayGraphic: #imageLiteral(resourceName: "BrickBreaker@2x.png"),
                           displayGraphicName: "BrickBreaker Logo")
        
        scene.createTitleText(title: "Building Brick Breaker",
                              description: "In this challenge, you build the Brick Breaker game.")
        
       
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [unowned self] _ in
            
             DispatchQueue.main.async {
                self.scene.clear()
                self.showIntroScreen2()
            }
        }
    }
    
    private func showIntroScreen2() {
        playSound(.pop1, volume: 75)
        scene.createBackgroundUI(background1: #colorLiteral(red: 1, green: 0.577706039, blue: 0, alpha: 1),
                           background1Gradient: #colorLiteral(red: 0.708224237, green: 0.09132572263, blue: 0, alpha: 1),
                           background2: #colorLiteral(red: 1, green: 0.577706039, blue: 0, alpha: 1),
                           background2Gradient: #colorLiteral(red: 0.708224237, green: 0.09132572263, blue: 0, alpha: 1),
                           dots: #colorLiteral(red: 0.9706322863, green: 0.5613346901, blue: 0.008627369278, alpha: 1),
                           displayGraphic: #imageLiteral(resourceName: "BrickBreaker@2x.png"),
                           displayGraphicName: "BrickBreaker Logo")
        
        scene.createTitleText(title: "What is Brick Breaker?", description: "Keep the ball from crossing the foul line, and smash all the bricks.")
        
       
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [unowned self] _ in
            DispatchQueue.main.async {
                playSound(.pop1, volume: 75)
                self.scene.clear()
                self.runLevel(index: 0)
            }
        }
    }
    
    override public func showGameOverScreen() {
        print("*** Game Over ***")
        DispatchQueue.main.async {
            print("*** clearing the screen ***")
            self.scene.clear()
            print("*** Navigate to the next page ***")
            PlaygroundPage.current.navigateTo(page:.next)
            print("*** Done ***")
        }
    }
}
