//
//  GameSceneViewController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

// Game Screen handler
class GameSceneViewController: UIViewController {
    private static let SKSPlaySceneFileName = "PlayScene"

    // this scene property will hold the unarchived Scene from .sks file
    private weak var scene: PlayScene?

    // own view reference
    private weak var skView: SKView?


	// re-create self.view to an SKView
    internal override func loadView() {
        self.view = SKView(frame: UIScreen.mainScreen().bounds)
    }

    // overriden event handler for viewDidLoad
    internal override func viewDidLoad() {
        super.viewDidLoad()

        // configure the view
        self.skView = (self.view as! SKView)

        // unarchive scene
		self.scene = PlayScene.unarchiveFromFile(GameSceneViewController.SKSPlaySceneFileName) as? PlayScene

        if self.scene != nil {
            // switch FPS and NODE COUNTER displayment
            self.skView!.showsFPS       = Defines.DEBUG.showFpsOnGameScene
            self.skView!.showsNodeCount = Defines.DEBUG.showNodeCountOnGameScene

			// sprite Kit applies additional optimizations to improve rendering performance
            self.skView!.ignoresSiblingOrder = true

            // set the scale mode to scale to fit the window
			self.scene!.scaleMode = SKSceneScaleMode.ResizeFill

            // give VC and the scene to the application
            app.getTransitionController().setGameSceneVC(self)
            app.setScene(self.scene!)

            // presenting play scene
            self.skView!.presentScene(self.scene!)
        }
    }

}
