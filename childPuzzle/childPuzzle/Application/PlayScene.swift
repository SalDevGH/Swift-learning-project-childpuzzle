//
//  GameScene.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import SpriteKit

// Handler class of the Scene which contains the game elements
// It is automatically starting the actual gameplay, plus handles the touch events on the scene
class PlayScene: SKScene {

    // called immediately after the scene is presented by a view
    internal override func didMoveToView(view: SKView) {
		super.didMoveToView(view)

		// start selected stage with current difficulty settings
        app.getStageController().startStage()
    }

    // Called when a touch has began
    internal override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !self.touchHandlingEnabled() {
            return
        }

		// getting info about the touch
		let (nodeName, node, touchLocation) = self.getNodeByTouchInfo(touches)

		// handle touch only when it is a matching item
		if nodeName == Defines.SKNODE_NAME.matchingItem {
			app.getStageController().onMatchingItemTouchBegan(node as! SKSpriteNode, location: touchLocation!)
		}
    }

    // Called when a touch is moved
    internal override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !self.touchHandlingEnabled() {
            return
        }

        if let location = self.getLocationByTouchInfo(touches) {
            app.getStageController().onTouchMoved(location)
        }
    }

    // Called when a touch ended
    internal override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !self.touchHandlingEnabled() {
            return
        }

		// getting info about the touch
		let (nodeName, node, _) = self.getNodeByTouchInfo(touches)

        // getting node's information by the touches
		switch nodeName! {
			// BACK button
			case Defines.SKNODE_NAME.backButton:
				app.getStageController().endStage(true)
				break

			// MATCHING ITEM
			case Defines.SKNODE_NAME.matchingItem:
				app.getStageController().onMatchingItemTouchEnded()
				break

			// MIRACLE ITEM
			case Defines.SKNODE_NAME.miracleItem:
				app.getStageController().onMiracleItemTouchEnded(node! as! SKSpriteNode)
				break

			default: break
		}
    }

	// tells whether handling of the touches are enabled on the scene
	private func touchHandlingEnabled() -> Bool {
		return !app.isGameOver()
	}

	// returns with a location of the first recognized touch
	// no multitouch supported
	private func getLocationByTouchInfo(touches: Set<UITouch>) -> CGPoint? {
		var location = CGPoint?()

		for touch: AnyObject in touches {
			location = touch.locationInNode(self.scene!)
		}

		return location
	}

	// returns with the name of the node which is touched and the node itself
	private func getNodeByTouchInfo(touches: Set<UITouch>) -> (String?, SKNode?, CGPoint?) {
		// trying to get location of first touch
		let location = self.getLocationByTouchInfo(touches)

		if location == nil {
			return (nil, nil, nil)
		}

		// get and return node data
		let node = self.scene!.nodeAtPoint(location!)

		return (node.name, node, location)
	}

}
