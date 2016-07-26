//
//  ItemController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// Parent controller of items
class ItemController {
    internal var model = ItemModel()


    // creates an item, places onto the scene, and sets it's default position and zPosition
	internal func create(data: ItemModel.itemData, position: CGPoint) -> SKSpriteNode {
        // instantiate new node
        let node = self.model.createNode(data)

		// setup
        self.setZPosition(node, z: data.zPosition)
        self.setPosition(node, position: position)

        return node
    }

    // removes a node from the scene
    internal func removeNode(node: SKSpriteNode) {
        self.model.removeNode(node)
    }

	// removes all nodes from the scene
	internal func removeAllNodes() {
		self.model.removeAllNodes()
	}

    // returns with the position of a node
    internal func getPosition(node: SKSpriteNode) -> CGPoint {
        return self.model.getPosition(node)
    }

    // sets the 2D position of a node
	internal func setPosition(node: SKSpriteNode, position: CGPoint) {
        self.model.setPosition(node, position: CGPointMake(app.getScene()!.frame.minX + position.x, position.y))
    }

    // sets the Z position of a node
    internal func setZPosition(node: SKSpriteNode, z: CGFloat) {
        self.model.setZPosition(node, z: z)
    }

    // returns a node by it's name
    internal func getNodeByName(name: String) -> SKSpriteNode? {
        return self.model.getNodeByName(name)
    }

    // returns all nodes, regardless of any object type
    internal func getAllInstances() -> [SKSpriteNode] {
        return self.model.getAllNodes()
    }

}
