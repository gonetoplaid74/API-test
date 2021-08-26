import Foundation

/// /*#-localizable-zone(usermodule9)*/A game in Brick Breaker. It runs the game, and manages the levels and the winning animation./*#-end-localizable-zone*/
public class Game {
    
    /// /*#-localizable-zone(usermodule10)*/The levels of the game./*#-end-localizable-zone*/
    var levels: [GameLevel] = []
    
    /// /*#-localizable-zone(usermodule11)*/Creates a game and sets its levels./*#-end-localizable-zone*/
    public init(levels: [GameLevel]) {
        self.levels = levels
    }
    
    /// /*#-localizable-zone(usermodule12)*/Runs one of the levels in the game./*#-end-localizable-zone*/
    public func runLevel(index: Int) {
        if index + 1 > levels.count {
            winGame()
        } else {
            levels[index].onCompletion = {
                self.runLevel(index: index + 1)
            }
            nextLevel(number: index + 1)
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {_ in
                self.levels[index].run()
            }
        }
    }
    
    /// /*#-localizable-zone(usermodule13)*/Run the game./*#-end-localizable-zone*/
    public func run() {
        runLevel(index: 0)
    }
    
    /// /*#-localizable-zone(usermodule14)*/Shows a message when moving to the next level./*#-end-localizable-zone*/
    func nextLevel(number: Int) {
        let nextLevelMessage = Label(text: "/*#-localizable-zone(gameText01)*/Level/*#-end-localizable-zone*/ \(number)", color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), font: .MarkerFelt,size: 120)
        scene.place(nextLevelMessage, at: Point(x: 0, y: 400))
        nextLevelMessage.fadeOut(after: 3)
    }
    
    /// /*#-localizable-zone(usermodule15)*/Called when you win the game./*#-end-localizable-zone*/
    func winGame() {
        let endMessage = Label(text: "/*#-localizable-zone(gameText02)*/YOU WIN/*#-end-localizable-zone*/", color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), font: .MarkerFelt, size: 120)
        scene.place(endMessage, at: Point(x: 0, y: 275))
        
    }
}
