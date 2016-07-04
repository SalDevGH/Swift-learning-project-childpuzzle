//
//  BackgroundModel.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// Model of background management in a given scene
class BackgroundModel {
    // node for the background
    private var bgNode = SKSpriteNode?()


    // creates a node and uses it for background
    internal func create(imageNamed: String) {
		let scene = app.getScene()!

        // create node
		let bgNode = SKSpriteNode(imageNamed: imageNamed)

        // setup
		bgNode.size      = CGSizeMake(scene.frame.maxX, scene.frame.maxY)
        bgNode.position  = CGPointMake(scene.frame.midX, scene.frame.midY)
		bgNode.zPosition = Defines.Z_INDEX_MAP.background
		bgNode.name      = Defines.SKNODE_NAME.background

        // populate scene
        scene.addChild(bgNode)
    }

    // destroys the background node
    internal func destroy() {
		let scene = app.getScene()!

		scene.removeChildrenInArray(scene[Defines.SKNODE_NAME.background] as! [SKSpriteNode])
    }

}
