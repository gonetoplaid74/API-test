import PlaygroundSupport
import SPCAssessment
import MyFiles

public class AssessmentManager {
    
    let learningTrails = LearningTrailsProxy()
    let fileFinder = UserModuleFileFinder()
    let mainFile = ContentsChecker(contents: PlaygroundPage.current.text)
    var levelFile: ContentsChecker
    var ballFile: ContentsChecker
    var paddleFile: ContentsChecker
    var brickFile: ContentsChecker
    var gameFile: ContentsChecker
    
    public init() {
        levelFile = ContentsChecker(contents: fileFinder.getContents(ofFile: "Level", module: "MyFiles"))
        ballFile = ContentsChecker(contents: fileFinder.getContents(ofFile: "Ball", module: "MyFiles"))
        paddleFile = ContentsChecker(contents: fileFinder.getContents(ofFile: "Paddle", module: "MyFiles"))
        brickFile = ContentsChecker(contents: fileFinder.getContents(ofFile: "Brick", module: "MyFiles"))
        gameFile = ContentsChecker(contents: fileFinder.getContents(ofFile: "Game", module: "MyFiles"))
    }
    
    public func runAssessmentPage01(level: Level) {
        // Add a Paddle
        if learningTrails.currentStep == "addPaddle" {
            if level.paddle.bounciness > 1.05 {
                learningTrails.sendMessageOnce("addPaddle-success")
                learningTrails.setAssessment("addPaddle", passed: true)
            } else {
                learningTrails.sendMessageOnce("addPaddle-hint")
            }
        }
           
        // Add a Ball
        if learningTrails.currentStep == "addBall" {
            if levelFile.functionCallCount(forName: "addBall") > 0 {
                learningTrails.sendMessageOnce("addBall-success")
                learningTrails.setAssessment("addBall", passed: true)
            } else {
                learningTrails.sendMessageOnce("addBall-hint")
            }
        }
        
        // Customize the Ball and Paddle
        if learningTrails.currentStep == "ballPaddleExperiments" {
            
            var changedBallOrPaddleImage = false
            var addedBallAnimations = false
            var customizedBall = false
            var customizedPaddle = false
            var startedBall = false
            var ballPaddleExperimentsStep5Passed = false
            var numOfExperiments = 0
            
            if level.ballImage !=  #imageLiteral(resourceName: "Ball_1@2x.png") || level.paddleImage != #imageLiteral(resourceName: "Paddle_6@2x.png") {
                changedBallOrPaddleImage = true
                numOfExperiments += 1
                learningTrails.setTask("ballAndPaddleImages", completed: true)
            }

            if levelFile.functionCallsInFunctionDefinition(named: "run").contains("ball.spark") || levelFile.functionCallsInFunctionDefinition(named: "run").contains("ball.tracer") {
                addedBallAnimations = true
                numOfExperiments += 1
                learningTrails.setTask("ballAnimation", completed: true)
            }
            
            for ball in level.balls {
                if ball.friction != 0.08 || ball.allowsRotation == false {
                    customizedBall = true
                    numOfExperiments += 1
                    learningTrails.setTask("customizeBall", completed: true)
                }
            }
            
            if level.paddle.xScale != 1.25 {
                customizedPaddle = true
                numOfExperiments += 1
                learningTrails.setTask("customizePaddle", completed: true)
            }
            
            if levelFile.functionCallsInFunctionDefinition(named: "run").contains("startBall") {
                startedBall = true
                numOfExperiments += 1
                learningTrails.setTask("countdown", completed: true)
                
            }
            
            ballPaddleExperimentsStep5Passed = changedBallOrPaddleImage || addedBallAnimations || customizedBall || customizedPaddle || startedBall
            
            if numOfExperiments > 2 {
                learningTrails.sendMessageOnce("ballPaddleExperiments-success2")
                
            } else if ballPaddleExperimentsStep5Passed {
                learningTrails.sendMessageOnce("ballPaddleExperiments-success1")
                learningTrails.setAssessment("ballPaddleExperiments", passed: true)
            } else {
                learningTrails.sendMessageOnce("ballPaddleExperiments-hint")
            }
            
        }
    }

    public func runAssessmentPage02(level: Level) {

        // Adding Bricks
        if learningTrails.currentStep == "addingBricks" {
            if level.brickCount > 3 {
                learningTrails.sendMessageOnce("addingBricks-success")
                learningTrails.setAssessment("addingBricks", passed: true)
            } else {
                learningTrails.sendMessageOnce("addingBricks-hint")
            }
        }

        // Customizing Your Layout
        if learningTrails.currentStep == "layoutExperiments" {
            var layoutExperimentsStep3Passed = false
            
            var createdOneColorLayout = false
            var createdColorArray = false
            var createdRandomColorLayout = false
            
            if mainFile.functionCallCount(forName: "Layout.color") > 0 && mainFile.passedArguments(forCall: "Level").contains("using:oneColorLayout") {
                createdOneColorLayout = true
                learningTrails.setTask("oneColor", completed: true)
            }
            
            // Check to see if they used the colors argument.
            if mainFile.passedArguments(forCall: "Layout").contains("colors:colors") && mainFile.passedArguments(forCall: "Level").contains("using:colorArrayLayout") {
                createdColorArray = true
                learningTrails.setTask("colorArray", completed: true)
            }
            
            // Check to see if they used the random method.
            if mainFile.functionCallCount(containing: "random") > 0 {
                let levelInit = mainFile.passedArguments(forCall: "Level")
                if levelInit.contains("using:randomColors") || levelInit.contains("using:randomColorsRowsColumns") {
                    createdRandomColorLayout = true
                    learningTrails.setTask("randomColors", completed: true)
                    
                }
            }
            
            layoutExperimentsStep3Passed = createdOneColorLayout || createdColorArray || createdRandomColorLayout
            
            if layoutExperimentsStep3Passed {
                learningTrails.sendMessageOnce("layoutExperiments-success")
                learningTrails.setAssessment("layoutExperiments", passed: true)
            } else {
                learningTrails.sendMessageOnce("layoutExperiments-hint")
            }
        }


        // Customizing Bricks
        if learningTrails.currentStep == "brickExperiments" {
            var brickExperimentsStep5Passed = false
            
            var changedBrickStrength = false
            var changedBrickImage = false
            var addedBall = false
            var changedPaddleWidth = false
            var knockedBrickLoose = false
            var makeBallPassThroughBricks = false
            var addedTurbo = false
            var addedAnimations = false
            
            let createBrickData = levelFile.allDataInFunction(named: "createBrick")

            let levelFileCalls = levelFile.calledFunctions
            let levelFileVars = levelFile.accessedVariables
            
            if createBrickData.contains("brick.strength") {
                changedBrickStrength = true
                learningTrails.setTask("brickStrength", completed: true)
            }
            
            if createBrickData.contains("brick.image") {
                changedBrickImage = true
                learningTrails.setTask("brickImage", completed: true)
            }
            
            if levelFileCalls.contains("self.addBall") && levelFileCalls.contains("ball.setVelocity")  {
                addedBall = true
                learningTrails.setTask("addABall", completed: true)
            }
            
            if levelFileVars.contains("self.paddle.xScale") {
                changedPaddleWidth = true
                learningTrails.setTask("paddleSizes", completed: true)
            }
            
            if levelFileVars.contains("brick.isDynamic") {
                knockedBrickLoose = true
                learningTrails.setTask("knockLoose", completed: true)
            }
            
            if levelFileVars.contains("brick.ballPassesThrough") {
                makeBallPassThroughBricks = true
                learningTrails.setTask("passThrough", completed: true)
            }
            
            if levelFileCalls.contains("ball.passThroughBrick") && levelFileCalls.contains("ball.spark") && levelFileCalls.contains("ball.setVelocity") {
                addedTurbo = true
                learningTrails.setTask("turbo", completed: true)
            }
            
            if createBrickData.contains("brick.addOnExplodeHandler") && (levelFileCalls.contains("ball.sparkle") || levelFileCalls.contains("ball.spark") || levelFileCalls.contains("self.paddle.glow")) {
                addedAnimations = true
                learningTrails.setTask("animations", completed: true)
            }
            
            brickExperimentsStep5Passed = changedBrickStrength || changedBrickImage || addedBall || changedPaddleWidth || knockedBrickLoose || makeBallPassThroughBricks || addedTurbo || addedAnimations
            
            if brickExperimentsStep5Passed {
                learningTrails.sendMessageOnce("brickExperiments-success")
                learningTrails.setAssessment("brickExperiments", passed: true)
            } else {
                learningTrails.sendMessageOnce("brickExperiments-hint")
            }
        }
    }
    
     
    public func runAssessmentPage03(level: Level) {
        
        let checkForCompletionData = levelFile.allDataInFunction(named: "checkForLevelCompletion")
        let winLevelData = levelFile.allDataInFunction(named: "winLevel")

        // Writing Your Winning Logic
        if learningTrails.currentStep == "winning" {
            // Writing Your Winning Logic
            if learningTrails.currentStep == "winning" {
                if checkForCompletionData.contains("brickCount") && checkForCompletionData.contains("brickCount==0.0") && checkForCompletionData.contains("winLevel") {
                    learningTrails.setAssessment("winning", passed: true)
                    learningTrails.sendMessageOnce("winning-success")
                } else if checkForCompletionData.contains("brickCount") && checkForCompletionData.contains("brickCount==0.0") && !checkForCompletionData.contains("winLevel") {
                    learningTrails.sendMessageOnce("winning-hint3")
                } else if checkForCompletionData.contains("brickCount") && !(checkForCompletionData.contains("brickCount==0.0") && checkForCompletionData.contains("winLevel")) {
                    learningTrails.sendMessageOnce("winning-hint1")
                } else {
                    learningTrails.sendMessageOnce("winning-hint2")
                }
            }
        }

        // Customizing the Rewward
        if learningTrails.currentStep == "winningExperiments" {
            var winningExperimentsStep3Passed = false
            
            var changedText = false
            var addedTextAnimations = false
            var addedSceneAnimations = false
            var addedSoundEffects = false
            var removedReward = false
            let labelArguments = levelFile.callNodesInFunctionDefinition(named: "winLevel").map { $0.arguments }.filter { $0.contains("text:") }
            if let labelArgument = labelArguments.first {
                if let range = labelArgument.range(of: #"(?<=text:)(.*)(?=,color:)"#, options: .regularExpression) {
                    let winString = labelArgument[range]
                    if winString != "\"🥳\"" {
                        changedText = true
                        learningTrails.setTask("rewardText", completed: true)
                    }
                }
            }
            
            
            if winLevelData.contains("reward.bounce") || winLevelData.contains("reward.glow") || winLevelData.contains("reward.shake") {
                addedTextAnimations = true
                learningTrails.setTask("rewardTextAnimations", completed: true)
            }
            
            
            if winLevelData.contains("scene.confetti") || winLevelData.contains("scene.bubbles") || winLevelData.contains("scene.orbs") {
                addedSceneAnimations = true
                learningTrails.setTask("rewardSceneAnimations", completed: true)
            }
            
            if winLevelData.contains("playSound") {
                addedSoundEffects = true
                learningTrails.setTask("rewardSoundEffects", completed: true)
            }
            
            if winLevelData.contains("removeReward") {
                removedReward = true
                learningTrails.setTask("rewardCleanUp", completed: true)
            }
            
            winningExperimentsStep3Passed = changedText || addedTextAnimations || addedSceneAnimations || addedSoundEffects || removedReward
            
            if winningExperimentsStep3Passed {
                learningTrails.setAssessment("winningExperiments", passed: true)
                learningTrails.sendMessageOnce("winningExperiments-success")
            } else {
                learningTrails.sendMessageOnce("winningExperiments-hint")
            }
        }
    }


    public func runAssessmentPage04(level: Level) {
        
        let hitFoulLineData = levelFile.allDataInFunction(named: "hitFoulLine")
        let loseLevelData = levelFile.allDataInFunction(named: "loseLevel")

        
        if learningTrails.currentStep == "foulLine" {
            if levelFile.functionCallsInFunctionDefinition(named: "run").contains("addFoulLine") {
                learningTrails.sendMessageOnce("foulLine-success")
                learningTrails.setAssessment("foulLine", passed: true)
            } else {
                learningTrails.sendMessageOnce("foulLine-hint")
            }
        }

        if learningTrails.currentStep == "losing" {
            if hitFoulLineData.contains("removeBall") && hitFoulLineData.contains("loseLevel") && hitFoulLineData.filter { $0.contains("balls.count==") }.count > 0 {
                learningTrails.sendMessageOnce("losing-success")
                learningTrails.setAssessment("losing", passed: true)
            } else {
                learningTrails.sendMessageOnce("losing-hint")
            }
        }

        // Customize Your Failure Condition
        if learningTrails.currentStep == "losingExperiments" {
            
            var losingExperimentsStep4Passed = false
            
            var changedText = false
            var animatedText = false
            var animatedScene = false
            var addedSoundEffects = false
            
            let loseLabelArguments = levelFile.callNodesInFunctionDefinition(named: "loseLevel").map { $0.arguments }.filter { $0.contains("text:") }
            
            if let loseLabelArgument = loseLabelArguments.first {
                if let range = loseLabelArgument.range(of: #"(?<=text:)(.*)(?=,color:)"#, options: .regularExpression) {
                    let loseString = loseLabelArgument[range]
                    if loseString != "\"😭\"" {
                        changedText = true
                        learningTrails.setTask("loseText", completed: true)
                    }
                }
            }
           
            
            if loseLevelData.contains("failure.bounce") || loseLevelData.contains("failure.glow") || loseLevelData.contains("failure.shake") {
                animatedText = true
                learningTrails.setTask("loseTextAnimations", completed: true)
            }
            
            if loseLevelData.contains("scene.clouds") || loseLevelData.contains("scene.rain") {
                animatedScene = true
                learningTrails.setTask("loseSceneAnimations", completed: true)
            }
            
            if loseLevelData.contains("playSound") {
                addedSoundEffects = true
                learningTrails.setTask("loseSoundEffects", completed: true)
            }
            
            losingExperimentsStep4Passed = changedText || animatedText || animatedScene || addedSoundEffects
            
            if losingExperimentsStep4Passed {
                learningTrails.sendMessageOnce("losingExperiments-success")
                learningTrails.setAssessment("losingExperiments", passed: true)
            } else {
                learningTrails.sendMessageOnce("losingExperiments-hint")
            }
        }
    }

    public func runAssessmentPage05(level: Level) {
        
        let hitFoulLineData = levelFile.allDataInFunction(named: "hitFoulLine")
        let levelFileCalls = levelFile.calledFunctions
        var hitFoulLineCalls = [String]()
        if let removeBallIndex = levelFileCalls.firstIndex(of: "removeBall") {
            hitFoulLineCalls = Array(levelFileCalls[removeBallIndex...(removeBallIndex + 4)])
        }
        
        // Adding Lives
        if learningTrails.currentStep == "addingLives" {
            if levelFile.variableAccessCount(forName: "lives")  > 0 {
                learningTrails.setAssessment("addingLives", passed: true)
                learningTrails.sendMessageOnce("addingLives-success")
            } else {
                learningTrails.sendMessageOnce("addingLives-hint")
            }
        }
        
        // New Losing Logic
        if learningTrails.currentStep == "losingLogic" {
            
            // This assessment could be improved in the future.
            if hitFoulLineCalls.contains("removeBall") && hitFoulLineCalls.contains("loseLevel") && hitFoulLineCalls.contains("addBall") && hitFoulLineCalls.contains("startBall") && hitFoulLineData.filter { $0.contains("balls.count==") }.count > 0 {
                learningTrails.setAssessment("losingLogic", passed: true)
                learningTrails.sendMessageOnce("losingLogic-success")
            } else {
                learningTrails.sendMessageOnce("losingLogic-hint")
            }
        }
        
    }

    public func runAssessmentPage06() {
        
        // Add a Completion Handler
        if learningTrails.currentStep == "completionHandler" {
            if levelFile.variableAccessCount(forName: "onCompletion")  > 0 {
                if levelFile.functionCallsInFunctionDefinition(named: "winLevel").contains("onCompletion") {
                    learningTrails.sendMessageOnce("completionHandler-success")
                    learningTrails.setAssessment("completionHandler", passed: true)
                } else {
                    learningTrails.sendMessageOnce("completionHandler-hint2")
                }
            } else {
                learningTrails.sendMessageOnce("completionHandler-hint")
            }
        }

        // Creating a Multilevel Game
        if learningTrails.currentStep == "multilevel" {
            let gameArgs = mainFile.passedArguments(forCall: "Game")

            if mainFile.variableAccessCount(forName: "game") > 0 && mainFile.functionCallCount(forName: "game.run") > 0 && gameArgs.filter { $0.contains("level1") && $0.contains("level2") }.count > 0 {
                    learningTrails.setAssessment("multilevel", passed: true)
                    learningTrails.sendMessageOnce("multilevel-success")
                } else {
                    learningTrails.sendMessageOnce("multilevel-hint")
                }
            }
        // Customize Each Level
        if learningTrails.currentStep == "levelExperiments" {
            
            var completionHandlerStep5Passed = false
            
            var changedBallImage = false
            var changedPaddleImage = false
            var changedPaddleWidth = false
            var changedDifficulty = false
            var changedLayout = false
            
            if mainFile.variableAccessCount(containing: "ballImage")  > 0 {
                changedBallImage = true
                learningTrails.setTask("levelBallImage", completed: true)
            }
            
            if mainFile.variableAccessCount(containing: "paddleImage")  > 0 {
                changedPaddleImage = true
                learningTrails.setTask("levelPaddleImage", completed: true)
            }
            
            if mainFile.variableAccessCount(containing: "paddle.xScale")  > 0 {
                changedPaddleWidth = true
                learningTrails.setTask("levelPaddleWidth", completed: true)
            }
            
            if mainFile.variableAccessCount(containing: "difficulty")  > 0 {
                changedDifficulty = true
                learningTrails.setTask("levelDifficulty", completed: true)
            }
            
            let arguments = mainFile.passedArguments(forCall: "Level")
            if arguments.filter { $0.contains("colors:colors") }.count < 1 {
                changedLayout = true
                learningTrails.setTask("levelLayout", completed: true)
            }
            
            completionHandlerStep5Passed = changedBallImage || changedPaddleImage || changedPaddleWidth || changedDifficulty  || changedLayout
            
            
            if completionHandlerStep5Passed {
                learningTrails.setAssessment("levelExperiments", passed: true)
                learningTrails.sendMessageOnce("levelExperiments-success")
            } else {
                learningTrails.sendMessageOnce("levelExperiments-hint")
            }
        }
        
        // Add More Levels
        if learningTrails.currentStep == "moreLevels" {
            if mainFile.calledFunctions.contains("game.run") && mainFile.calledFunctions.contains("Game") {
                if !mainFile.passedArguments(forCall: "Game").contains("levels:[level1,level2]") {
                    learningTrails.setAssessment("moreLevels", passed: true)
                    learningTrails.sendMessageOnce("moreLevels-success")
                } else {
                    learningTrails.sendMessageOnce("moreLevels-hint")
                }
            } else {
                learningTrails.sendMessageOnce("multilevel-hint")
            }
        }
        
        
        // Customize Win Game
        if learningTrails.currentStep == "winGameExperiments" {
            var winGameExperimentsStep7Passed = false
            
            var changedText = false
            var addedTextAnimations = false
            var addedSceneAnimations = false
            var addedSoundEffects = false
            
            let winGameData = gameFile.allDataInFunction(named: "winGame")
            
            let winGameArguments = gameFile.callNodesInFunctionDefinition(named: "winGame").map { $0.arguments }.filter { $0.contains("text:") }
            
            if let labelArgument = winGameArguments.first {
                if let range = labelArgument.range(of: #"(?<=text:)(.*)(?=,color:)"#, options: .regularExpression) {
                    let winGameString = labelArgument[range]
                    if winGameString != "\"YOUWIN\"" {
                        changedText = true
                        learningTrails.setTask("gameText", completed: true)
                    }
                }
            }
            
            if winGameData.contains("endMessage.spin") || winGameData.contains("endMessage.sparkle") || winGameData.contains("endMessage.pulsate") {
                addedTextAnimations = true
                learningTrails.setTask("gameTextAnimation", completed: true)
            }
            
            if winGameData.contains("scene.confetti") || winGameData.contains("scene.bubbles") || winGameData.contains("scene.orbs") {
                addedSceneAnimations = true
                learningTrails.setTask("gameSceneAniation", completed: true)
            }
            
            if winGameData.contains("playSound") {
                addedSoundEffects = true
                learningTrails.setTask("gameSoundEffects", completed: true)
            }
            
            winGameExperimentsStep7Passed = changedText || addedTextAnimations || addedSceneAnimations || addedSoundEffects
            
            if winGameExperimentsStep7Passed {
                learningTrails.setAssessment("winGameExperiments", passed: true)
                learningTrails.sendMessageOnce("winGameExperiments-success")
            } else {
                learningTrails.sendMessageOnce("winGameExperiments-hint")
            }
        }
    }
    
}
