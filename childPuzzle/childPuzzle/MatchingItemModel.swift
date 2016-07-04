//
//  MatchingItemModel.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// This model handles all the Matching-item nodes which are appearing on the scene
class MatchingItemModel: ItemModel {

	// all the keys which are used in the userData property of the nodes
	private enum userDataKeyNames: String {
		case idStage, idPlayItem, alias, startX, startY, winningX, winningY, playable
	}

	// all relevant information can be stored in this structure about a matching item
	internal struct matchingItemData {
		var idPlayItem: Int
		var idStage: Int
		var alias: String
		var nodeName: String
		var width: CGFloat
		var height: CGFloat
		var winningPosition: CGPoint
		var startPosition: CGPoint
		var zPosition: CGFloat
		var playable: Bool
		var userData: NSMutableDictionary?
	}


    // creates a matching item, places onto the scene
	// it also saves all relevant informations into the userData for later use
	internal func createNode(data: MatchingItemModel.matchingItemData) -> SKSpriteNode {
		let userDataDictionary = NSMutableDictionary()

		userDataDictionary.setValue(data.idPlayItem, forKey: userDataKeyNames.idPlayItem.rawValue)
		userDataDictionary.setValue(data.idStage, forKey: userDataKeyNames.idStage.rawValue)
		userDataDictionary.setValue(data.alias, forKey: userDataKeyNames.alias.rawValue)
		userDataDictionary.setValue(data.startPosition.x, forKey: userDataKeyNames.startX.rawValue)
		userDataDictionary.setValue(data.startPosition.y, forKey: userDataKeyNames.startY.rawValue)
		userDataDictionary.setValue(data.winningPosition.x, forKey: userDataKeyNames.winningX.rawValue)
		userDataDictionary.setValue(data.winningPosition.y, forKey: userDataKeyNames.winningY.rawValue)
		userDataDictionary.setValue(data.playable, forKey: userDataKeyNames.playable.rawValue)

        // create new item
		let node = super.createNode(ItemModel.itemData(
			alias: data.alias,
			nodeName: data.nodeName,
			width: data.width,
			height: data.height,
			zPosition: data.zPosition,
			userData: userDataDictionary
		))

        return node
    }

    // returns with the winning position of a matching item
    internal func getWinningPositionForItem(node: SKSpriteNode) -> CGPoint {
		return CGPointMake(
			node.userData!.objectForKey(userDataKeyNames.winningX.rawValue) as! CGFloat,
			node.userData!.objectForKey(userDataKeyNames.winningY.rawValue) as! CGFloat
		)
    }

	// returns with the alias of a matching item
	internal func getAliasOfNode(node: SKSpriteNode) -> String {
		return node.userData!.objectForKey(userDataKeyNames.alias.rawValue) as! String
	}

	// returns with all the matching item nodes
	internal override func getAllNodes() -> [SKSpriteNode] {
		return app.getScene()![Defines.SKNODE_NAME.matchingItem] as! [SKSpriteNode]
	}

	// constructs a struct of matchingItemData by a node
	internal func getMatchingItemDataByNode(node: SKSpriteNode) -> MatchingItemModel.matchingItemData {
		return MatchingItemModel.matchingItemData(
			idPlayItem: node.userData!.objectForKey(userDataKeyNames.idPlayItem.rawValue) as! Int,
			idStage: node.userData!.objectForKey(userDataKeyNames.idStage.rawValue) as! Int,
			alias: self.getAliasOfNode(node),
			nodeName: node.name!,
			width: node.frame.width,
			height: node.frame.height,
			winningPosition: self.getWinningPositionForItem(node),
			startPosition: CGPointMake(
								node.userData!.objectForKey(userDataKeyNames.startX.rawValue) as! CGFloat,
								node.userData!.objectForKey(userDataKeyNames.startY.rawValue) as! CGFloat
						   ),
			zPosition: node.zPosition,
			playable: node.userData!.objectForKey(userDataKeyNames.playable.rawValue) as! Bool,
			userData: node.userData!
		)
	}

}
