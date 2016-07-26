//
//  ApplicationBase.swift
//  childPuzzle
//
//  Created by Gabor on 6/26/16.
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SQLite
import SpriteKit

/* This base class implements a typical gameflow and a frame for a game which uses a SQLite database, a menu system,
a stage selection scene, and a SpriteKit game scene.

Which classes/structs/extensions are needed at a minimum to use this class:
	- Class: ConfigController
	- Class: DatabaseController
	- Class: StageController
	- Class: SoundController
	- Class: SceneTransitionController
	- Struct: Defines
	- Ext: CGFloatResize
	- Ext: SKSpriteNodeResize

This class already requires (parts of the) the following values and structs from the Defines struct:
	- DIFFICULTY_LEVEL
	- FILE_SQLITE3_DATABASE
	- TIMING
	- SEQUE_ID
	- AUDIO_CFG
	- SKNODE_NAME
	- UI_BACK_BUTTON
	- DEFAULT_APPLICATION_SETTINGS
	- DEBUG

Which things needs to be implemented in any subclass of this:
	- game state handling
	- custom features
	- overridden, custom handleMemoryWarning() method

*/
class SpriteKitGameBase {
	// common controllers
	internal var soundControllerMenu  = SoundController()
	internal var stageController      = StageController()
	internal var dbController         = DatabaseController()
	internal var configController     = ConfigController(autoSave: true)
	internal var transitionController = SceneTransitionController()

	// configuration properties
	internal var isMusicEnabled:Bool {
		get { return self.configController.isMusicEnabled }
		set { self.configController.isMusicEnabled = newValue }
	}
	internal var isSoundEffectsEnabled:Bool {
		get { return self.configController.isSoundEffectsEnabled }
		set { self.configController.isSoundEffectsEnabled = newValue }
	}
	internal var currentDifficultyLevel:Int {
		get { return self.configController.currentDifficultyLevel }
		set { self.configController.currentDifficultyLevel = newValue }
	}
	internal var selectedStageIndex = 0

	// the game's scene object
	internal var _scene:SKScene?
	internal weak var scene:SKScene? {
		get {
			return self._scene
		}
		set {
			self._scene = newValue
		}
	}


	// constructs the application
	internal init() {
		self.dbController.setUpDatabaseConnection(
			Defines.FILE_SQLITE3_DATABASE.fileName,
			sqlLiteFileExt: Defines.FILE_SQLITE3_DATABASE.fileExtension
		)

		// verifying and reading up application configuration
		self.configController.ensureAllSettingsArePresent()
	}

	// kickstarts the application. this is called from menu system, when the application is ready to go
	internal func start() {
		// init stage controller
		self.stageController.start()
	}

	// generates and returns with a random integer between 0 (inclusively) and max (exclusively)
	// so a call randInt(5) yields an int between 0-4
	internal func randInt(max: Int) -> Int {
		return Int(arc4random_uniform(UInt32(max)))
	}

	// getter for the play scene
	internal func getScene() -> SKScene? {
		return self.scene
	}

	// setter for the play scene
	internal func setScene(scene: SKScene) {
		self.scene = scene
	}

	// getter for selected stage
	internal func getSelectedStageIndex() -> Int {
		return self.selectedStageIndex
	}

	// setter for selected stage
	internal func setSelectedStageIndex(index: Int) {
		var selectedIndex = index

		if (index < 1) || (index > self.stageController.getNumberOfStages()) {
			selectedIndex = 1
		}

		self.selectedStageIndex = selectedIndex
	}

	// tells if sound effects are enabled
	internal func getSoundEffectsEnabled() -> Bool {
		return self.isSoundEffectsEnabled
	}

	// setter for enable / disable sound effects
	internal func setSoundEffectsEnabled(enabled: Bool) {
		self.isSoundEffectsEnabled = enabled
	}

	// tells if music is enabled
	internal func getMusicEnabled() -> Bool {
		return self.isMusicEnabled
	}

	// setter for enable / disable music
	internal func setMusicEnabled(enabled: Bool) {
		self.isMusicEnabled = enabled
	}

	// getter for the currently selected difficulty level
	internal func getCurrentDifficultyLevel() -> Int {
		return self.currentDifficultyLevel
	}

	// setter for the currently selected difficulty level
	internal func setCurrentDifficultyLevel(level: Int) {
		self.currentDifficultyLevel = level
	}

	// getter for stageController
	internal func getStageController() -> StageController {
		return self.stageController
	}

	// getter for sound controller of the menu system
	internal func getSoundControllerOfMenu() -> SoundController {
		return self.soundControllerMenu
	}

	// getter for the database controller
	internal func getDBController() -> DatabaseController {
		return self.dbController
	}

	internal func getTransitionController() -> SceneTransitionController {
		return self.transitionController
	}

	// general method which can be called from all scenes
	internal func handleMemoryWarning() {
	}

}