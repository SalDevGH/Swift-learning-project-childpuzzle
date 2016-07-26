//
//  FrogMiracleController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

class FrogMiracleController: MiracleItemController {

    // called when player has initiated a miracle item
	internal override func performMiracle(node: SKSpriteNode, soundController: SoundController) {
		// do magic
        if app.getSoundEffectsEnabled() {
            soundController.playEffect((self.model as! MiracleItemModel).getAliasOfNode(node))
        }
    }

}
