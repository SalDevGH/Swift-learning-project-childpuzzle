//
//  SceneTransitionManager.swift
//  childPuzzle
//
//  Created by Gabor on 6/27/16.
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation

// This class handles programatic scene transitions
class SceneTransitionController {
	// view-controller references in order to perform seques
	internal weak var vcStageSelection = StageSelectionViewController?()
	internal weak var vcGameScene      = GameSceneViewController?()
	internal weak var vcMainMenu       = MainMenuViewController?()

	
	// switching scene from main menu to game scene
	internal func presentGameSceneFromMainMenu() {
		self.vcMainMenu!.performSegueWithIdentifier(Defines.SEQUE_ID.showGameFromMainMenu, sender: nil)
	}

	// switching scene from stage selection to game scene
	internal func presentGameSceneFromStageSelection() {
		self.vcStageSelection!.performSegueWithIdentifier(Defines.SEQUE_ID.showGameFromStageSelection, sender: nil)
	}

	// switching scene from game scene to stage selection
	internal func presentStageSelectionFromGameScene() {
		self.vcMainMenu!.disableStartAutoPlaying(true)
		self.vcGameScene!.performSegueWithIdentifier(Defines.SEQUE_ID.unWindToStageSelection, sender: nil)
		self.setGameSceneVC(nil)
		self.setStageSelectionVC(nil)
	}

	// switching scene from game to main menu
	internal func presentMainMenuFromGameScene() {
		self.vcMainMenu!.disableStartAutoPlaying(true)
		self.vcGameScene!.performSegueWithIdentifier(Defines.SEQUE_ID.unWindToMainMenu, sender: nil)
		self.setGameSceneVC(nil)
		self.setStageSelectionVC(nil)
	}

	// setter for main menu viewController
	internal func setMainMenuVC(vc: MainMenuViewController?) {
		self.vcMainMenu = vc
	}

	// getter for main menu viewController
	internal func getMainMenuVC() -> MainMenuViewController? {
		return self.vcMainMenu
	}

	// setter for stage selection viewController
	internal func setStageSelectionVC(vc: StageSelectionViewController?) {
		self.vcStageSelection = vc
	}

	// getter for stage selection viewController
	internal func getStageSelectionVC() -> StageSelectionViewController? {
		return self.vcStageSelection
	}

	// setter for game scene viewController
	internal func setGameSceneVC(vc: GameSceneViewController?) {
		self.vcGameScene = vc
	}

	// getter for game scene viewController
	internal func setGameSceneVC() -> GameSceneViewController? {
		return self.vcGameScene
	}
}