//
//  MatchingItemController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// This class is the manager of the playable and non-playable matching items
class MatchingItemController: ItemController {
	// this number will be used as a divisor to control the birthrate of the particle systems
	private let particleBirthRateDivisor: CGFloat = 30

	// this number will be used as a divisor to control the position range of the particle systems
	private let particlePositionRangeDivisor: CGFloat = 1.5


    // 2nd pass init
    internal func start() {
        self.model = MatchingItemModel()
    }

    // creates an item, and sets its position on the scene
	// if the item is playable, this will also create placeholder emmitter which will be placed 
	// in the winning position of the item
	internal func create(data: MatchingItemModel.matchingItemData, playable: Bool) -> SKSpriteNode {
        // instantiate new node
        let node = (self.model as! MatchingItemModel).createNode(data)

        // setup
        self.setZPosition(node, z: data.zPosition)
        self.setPosition(node, position: data.startPosition)

		// create placeholder particle effect
		if playable {
			self.createPlaceHolderEmmitter(data)
		}

        return node
    }

    // returns with the winning position of an item
    internal func getWinningPositionForItem(node: SKSpriteNode) -> CGPoint {
		return (self.model as! MatchingItemModel).getWinningPositionForItem(node)
    }

    // tells whether the item is *about* at the winning position
    internal func isItemAboutInWinningPosition(node: SKSpriteNode) -> Bool {
		// return false
		return self.isPositionNearEnoughToWin(
			(self.model as! MatchingItemModel).getPosition(node),
			itemData: (self.model as! MatchingItemModel).getMatchingItemDataByNode(node)
		)
    }

	// tells whether a position is near enough to its winning position to consider it as a success matching
	// the method doesn't looks for a perfect placing, but it applies a margin to decide (equal to the width and 
	// height of the item)
	internal func isPositionNearEnoughToWin(currentPosition: CGPoint,
	                                        itemData: MatchingItemModel.matchingItemData) -> Bool {

		let marginX  = itemData.width
		let marginY  = itemData.height
		let winningX = itemData.winningPosition.x
		let winningY = itemData.winningPosition.y
		let currentX = currentPosition.x
		let currentY = currentPosition.y

		return (currentX + marginX > winningX) && (currentX - marginX <= winningX) &&
			   (currentY + marginY > winningY) && (currentY - marginY <= winningY)
	}

    // precisely moves an item to it's place
    internal func setItemToWinningPosition(node: SKSpriteNode) {
        let winningPosition = (self.model as! MatchingItemModel).getWinningPositionForItem(node)

		// moving to the winning position
        self.setPosition(node, position: winningPosition)
        self.model.setZPosition(node, z: Defines.Z_INDEX_MAP.matchedItems)

		// removing related emmitter
		self.removePlaceHolderEmmitterByAlias((self.model as! MatchingItemModel).getAliasOfNode(node))
    }

	// populates the scene with a placeholder emmitter to let the player know where to place the item
	internal func createPlaceHolderEmmitter(data: MatchingItemModel.matchingItemData) {
		let emmitter = SKEmitterNode(fileNamed: Defines.FILE_NAME_PARTICLE_PLACEHOLDER)!

		emmitter.name                  = self.getEmmitterNameOfPlayItem(data.alias)
		emmitter.position              = data.winningPosition
		emmitter.zPosition             = Defines.Z_INDEX_MAP.itemParticleSys
		emmitter.particleBirthRate     = data.width / self.particleBirthRateDivisor
		emmitter.particlePositionRange = CGVector(
			dx: data.width / self.particlePositionRangeDivisor,
			dy: data.height / self.particlePositionRangeDivisor
		)

		// add particle node to scene
		app.getScene()!.addChild(emmitter)
	}

	// removes the placeholder emmitter of an item
	internal func removePlaceHolderEmmitterByAlias(alias: String) {
		let scene = app.getScene()!
		scene.removeChildrenInArray(scene[self.getEmmitterNameOfPlayItem(alias)])
	}

	// returns with an emmiter name which is used for an item with the given alias
	internal func getEmmitterNameOfPlayItem(alias: String) -> String {
		return "\(Defines.SKNODE_NAME.particleSystem)-\(alias)"
	}

}
