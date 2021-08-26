//#-hidden-code
//
//  Cutscene.swift
//
//  Copyright © 2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code

import PlaygroundSupport
import CutSceneGame
import MyFiles

let liveViewController = CutSceneGameViewController()

liveViewController.backgroundImage = #imageLiteral(resourceName: "background2.png")
PlaygroundPage.current.liveView = liveViewController

let game = CutSceneGame()
let level = Level()
game.add(level: level)
game.run()
