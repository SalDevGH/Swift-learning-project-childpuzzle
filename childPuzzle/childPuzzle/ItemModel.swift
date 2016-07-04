//
//  ItemModel.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// This model class represents a general visual item which can be used for playing
class ItemModel {
	// all relevant information can be stored in this structure about an item
	internal struct itemData {
		var alias: String
		var nodeName: String
		var width: CGFloat
		var height: CGFloat
		var zPosition: CGFloat
		var userData: NSMutableDictionary?
	}


	// creates a new node, appends it to the scene,
    // returns with the newly created node for later use
	internal func createNode(data: ItemModel.itemData) -> SKSpriteNode {
		// create, setup node
        let node        = SKSpriteNode(imageNamed: data.alias)
		let selfSize    = node.calculateAccumulatedFrame().size
		let aspectRatio = selfSize.width / selfSize.height

		node.name     = data.nodeName
		node.userData = data.userData
		node.size     = CGSizeMake(data.width, data.width / aspectRatio)
		node.convertForDevices()

        // populate scene
        app.getScene()!.addChild(node)

        return node
    }

    // removes a node from the scene
    // intended to be called from outer scopes as well
    internal func removeNode(node: SKSpriteNode) {
        app.getScene()!.removeChildrenInArray([node])
    }

    // removes a node instance from the scene
    // intended to be called from outer scopes as well
    internal func removeAllNodes() {
        app.getScene()!.removeAllChildren()
    }

    // returns with all the nodes
    internal func getAllNodes() -> [SKSpriteNode] {
		return app.getScene()!.children as! [SKSpriteNode]
    }

    // returns with one node by node name. if multiple nodes are existing with the given name, the first one 
	// will be returned. it gives nil when node is not found
    internal func getNodeByName(name: String) -> SKSpriteNode? {
		let nodeList = app.getScene()![name] as! [SKSpriteNode]

		if nodeList.count > 0 {
			return nodeList[0]
		}

        return nil
    }

	// returns with the position of a node
	internal func getPosition(node: SKSpriteNode) -> CGPoint {
		return node.position
	}

    // re-positions a node to a specific position
	internal func setPosition(node: SKSpriteNode, position: CGPoint) {
        node.position = position
    }

    // sets the Z position of a node
    internal func setZPosition(node: SKSpriteNode, z: CGFloat) {
        node.zPosition = z
    }

}
