//
//  CutSceneGameViewController.swift
//
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import BrickBreakerLiveView
import SPCCore
import SPCLiveView
import SPCScene
import SPCAudio
import SPCIPC
import SPCAccessibility
import SPCLearningTrails
import PlaygroundSupport
import UIKit

public class CutSceneGameViewController: LiveViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
        

        classesToRegister = [SceneProxy.self, AudioProxy.self, AccessibilityProxy.self]
        let liveViewScene = LiveViewScene(size: Scene.sceneSize)
        
        Message.isLiveViewOnly = true
        liveViewScene.liveViewMessageConnectionOpened()
        
        let learningTrailsButton = LearningTrailsBarButton()
        
        lifeCycleDelegates = [audioController, liveViewScene, learningTrailsButton]
        contentView = liveViewScene.skView
        
        let audioButton = AudioBarButton()
        
        audioButton.toggleBackgroundAudioOnly = true
        
        addBarButton(audioButton)
        addBarButton(learningTrailsButton)
    }

    required init?(coder: NSCoder) {
        fatalError("BrickBreakerViewController.init?(coder) not implemented.")
    }
}

