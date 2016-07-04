//
//  CatMiracleController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

class CatMiracleController: MiracleItemController {
	private let fixedAliasName   = "cat"
	private let animAtlasName    = "runningCatAtlas"
	private let animKeyName      = "runningCat"
	private let miracleDuration  = 1.2 // seconds
	private let movePhaseCount   = 4
	private let moveRangeOnY     = 60
	private let animPlayCount    = 3
	private let animTimePerFrame = 0.055
	private var animFrames       = [SKTexture]()


	// prepares the animation
	internal override func start() {
		super.start()

		let catAnimAtlas = SKTextureAtlas(named: self.animAtlasName)
		let numImages = catAnimAtlas.textureNames.count

		for i in 0 ..< numImages {
			let textureName = "\(fixedAliasName)\(i)"
			self.animFrames.append(catAnimAtlas.textureNamed(textureName))
		}
	}

	// called when player has initiated a miracle item
	internal override func performMiracle(node: SKSpriteNode, soundController: SoundController) {
		// do magic
		if app.getSoundEffectsEnabled() {
			soundController.playEffect((self.model as! MiracleItemModel).getAliasOfNode(node))
		}

		// start moving the cat
		let currentX               = node.position.x
		let currentY               = node.position.y
		let finalX                 = app.getStageController().getSceneBounds().width + node.size.width
		let finalY                 = currentY
		let alterY                 = currentY + CGFloat(self.moveRangeOnY)
		let distancePerPhase       = (finalX - currentX) / CGFloat(self.movePhaseCount)
		let durationPerPhase       = self.miracleDuration / Double(self.movePhaseCount)
		var movePhases: [SKAction] = []
		var newPosition: CGPoint

		for i in 1 ..< self.movePhaseCount + 1 {
			newPosition = CGPointMake(currentX + CGFloat(i) * distancePerPhase, (i % 2 == 0 ? finalY : alterY))
			movePhases.append(
				SKAction.moveTo(
					newPosition,
					duration: durationPerPhase
				)
			)
		}
		node.runAction(SKAction.sequence(movePhases))

		// start running animation of the cat
		node.runAction(SKAction.repeatAction(SKAction.animateWithTextures(
			self.animFrames,
			timePerFrame: self.animTimePerFrame,
			resize: false,
			restore: true
		), count: self.animPlayCount), withKey: animKeyName)
	}

}
