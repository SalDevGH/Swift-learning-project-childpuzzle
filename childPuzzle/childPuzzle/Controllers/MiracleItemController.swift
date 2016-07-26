//
//  MiracleItemController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

class MiracleItemController: ItemController {

    // called when starting the application
	internal func start() {
        self.model = MiracleItemModel()
    }

    // creates a miracle item, and sets its position on the scene
	internal func create(data: MiracleItemModel.miracleItemData) -> SKSpriteNode {
        // instantiate new item
		let node = (self.model as! MiracleItemModel).createNode(data)

        // setting z-index
        self.setZPosition(node, z: data.zPosition)

        // set up position
        self.setPosition(node, position: data.startPosition)

        return node
    }

    // called when player has initiated the miracle on an item
    // this should be overwritten in child classes
	internal func performMiracle(node: SKSpriteNode, soundController: SoundController) {
    }

    // tells whether an item is performed it's miracle
    internal func isMiraclePerformedOnNode(node: SKSpriteNode) -> Bool {
        return (self.model as! MiracleItemModel).isMiraclePerformed(node)
    }

    // returns with the type of the node
    internal func getTypeOfNode(node: SKSpriteNode) -> String {
        return (self.model as! MiracleItemModel).getTypeOfNode(node)
    }

	// returns with the alias of the node
	internal func getAliasOfNode(node: SKSpriteNode) -> String {
		return (self.model as! MiracleItemModel).getAliasOfNode(node)
	}

}
