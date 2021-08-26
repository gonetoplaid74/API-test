//
//  BrickBreakerViewController.swift
//
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import SPCCore
import SPCLiveView
import SPCScene
import SPCAudio
import SPCAccessibility
import PlaygroundSupport
import UIKit

public class BrickBreakerViewController: LiveViewController {
    
    private var accessibilityManager: AccessibilityManager?
    private var accessibilityButton: AccessibilityButton?

    public init() {        
        super.init(nibName: nil, bundle: nil)
                
        LiveViewController.contentPresentation = .aspectFitMinimum
        
        classesToRegister = [SceneProxy.self, AudioProxy.self, AccessibilityProxy.self]
        let liveViewScene = LiveViewScene(size: Scene.sceneSize)
        
        let accessibilityManager = AccessibilityManager(scene: liveViewScene)
        accessibilityManager.delegate = self
        self.accessibilityManager = accessibilityManager
        
        let accessibilityButton = AccessibilityButton(manager: accessibilityManager)
        accessibilityButton.isEnabled = false
        self.accessibilityButton = accessibilityButton
                
        lifeCycleDelegates = [audioController, liveViewScene, accessibilityManager]
        contentView = liveViewScene.skView
        
        // Debugging Physics Bodies
//        liveViewScene.skView.showsPhysics = true
//        liveViewScene.skView.showsFPS = true
        
        addBarButton(accessibilityButton)
    }

    required init?(coder: NSCoder) {
        fatalError("BrickBreakerViewController.init?(coder) not implemented.")
    }
}

// Implementing this indirectly via AccessibilityManager due to this limitation:
// "Overriding non-@objc declarations from extensions is not supported" if you attempt
// to conform BrickBreakerViewController to LiveViewLifeCycleProtocol.
extension BrickBreakerViewController: AccessibilityManagerDelegate {
    
    public func liveViewMessageConnectionClosed(_ manager: AccessibilityManager) {
        accessibilityButton?.dismissConfigurationMenu()
        accessibilityButton?.isEnabled = false
        accessibilityButton?.tintColor = .gray
    }
    
    public func liveViewMessageConnectionOpened(_ manager: AccessibilityManager) {
        accessibilityButton?.isEnabled = true
        accessibilityButton?.tintColor = .systemBlue
    }
}

