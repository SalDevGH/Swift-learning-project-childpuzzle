//
//  MiracleItemModel.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// This model handles all the Miracle-item nodes which are appearing on the scene
class MiracleItemModel: ItemModel {
	// all the keys which are used in the userData property of the nodes
	private enum userDataKeyNames: String {
		case idMiracleItem, type, alias, isPerformed
	}

	// all relevant information can be stored in this structure about a miracle item
	internal struct miracleItemData {
		var idMiracleItem: Int
		var type: String // 'oneTime', 'forever'
		var alias: String
		var nodeName: String
		var width: CGFloat
		var height: CGFloat
		var startPosition: CGPoint
		var zPosition: CGFloat
		var userData: NSMutableDictionary?
	}


	// creates a miracle item, places onto the scene
	// it also saves all relevant informations into the userData for later use
	internal func createNode(data: MiracleItemModel.miracleItemData) -> SKSpriteNode {
		let userDataDictionary = NSMutableDictionary()

		userDataDictionary.setValue(data.idMiracleItem, forKey: userDataKeyNames.idMiracleItem.rawValue)
		userDataDictionary.setValue(data.type, forKey: userDataKeyNames.type.rawValue)
		userDataDictionary.setValue(data.alias, forKey: userDataKeyNames.alias.rawValue)
		userDataDictionary.setValue(false, forKey: userDataKeyNames.isPerformed.rawValue)

        // let the parent handle the creation
		let node = super.createNode(ItemModel.itemData(
			alias:     data.alias,
			nodeName:  data.nodeName,
			width:     data.width,
			height:    data.height,
			zPosition: data.zPosition,
			userData:  userDataDictionary
		))

        return node
    }

    // returns with the type of an item
    internal func getTypeOfNode(node: SKSpriteNode) -> String {
		return node.userData!.objectForKey(userDataKeyNames.type.rawValue) as! String
    }

	// returns with the alias of an item
	internal func getAliasOfNode(node: SKSpriteNode) -> String {
		return node.userData!.objectForKey(userDataKeyNames.alias.rawValue) as! String
	}

    // sets a miracle item as performed (used)
    internal func setMiraclePerformed(node: SKSpriteNode) {
        if !self.isMiraclePerformed(node) {
			node.userData!.setValue(true, forKey: userDataKeyNames.isPerformed.rawValue)
        }
    }

    // tells whether an item is performed its miracle, regardless of its type
    internal func isMiraclePerformed(node: SKSpriteNode) -> Bool {
		return node.userData![userDataKeyNames.isPerformed.rawValue] as! Bool
    }

	// returns with all the miracle item nodes
	internal override func getAllNodes() -> [SKSpriteNode] {
		return app.getScene()![Defines.SKNODE_NAME.miracleItem] as! [SKSpriteNode]
	}

}
