//
//  Defines.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// global configuration
internal struct Defines {
	// all difficulty levels
	enum DIFFICULTY_LEVEL:Int {
		case easy = 0, medium, hard
	}

	// defines all duration intervals which controls the game's dynamics
	// every value is in seconds
	struct TIMING {
		static let settingsPanelOpen     = 0.5 // duration of opening the settings panel
		static let settingsPanelClose    = 0.5 // duration of closing the settings panel
		static let settingsButtonMoveOut = 0.8 // duration of moving out the settings button
		static let settingsButtonMoveIn  = 0.4 // duration of moving in the settings button
		static let sceneFadeIn           = 2.0 // duration of fading in the stage when the game is starting
		static let sceneFadeOut          = 4.0 // duration of fading out the stage when the game is over
		static let sceneChange           = 5.0 // duration to wait before changing to the next scene
		static let gameMusicFadeIn       = 3.0 // duration of fade-in effect of game music
		static let gameMusicFadeOut      = 1.0 // duration of fade-out effect of game music
		static let menuMusicFadeIn       = 1.0 // duration of the fade-in effect of menu music
		static let menuMusicFadeOut      = 1.0 // duration of the fade-out effect of menu music
	}

	// seque ID's to perform when changing scenes programatically
	struct SEQUE_ID {
		static let showGameFromStageSelection = "ShowGameScene"
		static let showGameFromMainMenu       = "ShowGameSceneFromMainMenu"
		static let unWindToStageSelection     = "unwindToStageSelectionFromGameScene"
		static let unWindToMainMenu           = "unwindSequeToMainMenuFromGameScene"
	}

	// SQL LITE config
	struct FILE_SQLITE3_DATABASE {
		static let fileName      = "BabyMiracleMatch"
		static let fileExtension = "db"
	}

	// particle system file for non-matched items
	static let FILE_NAME_PARTICLE_PLACEHOLDER = "nonMatchedItemPlaceHolder.sks"

	// used z-indexes for various kind of items on the scene
	struct Z_INDEX_MAP {
		static let background:CGFloat           = 1.0
        static let matchedItems:CGFloat         = 2.0
        static let miracleItems:CGFloat         = 3.0
		static let itemParticleSys:CGFloat      = 4.0
        static let items:CGFloat                = 5.0
        static let activeMiracleItems:CGFloat   = 6.0
        static let currentlyDraggedItem:CGFloat = 7.0
		static let controlItems:CGFloat         = 8.0
    }

	// node names used in the node tree
	struct SKNODE_NAME {
		static let background     = "BACKGROUND"
		static let matchingItem   = "MATCHING_ITEM"
		static let miracleItem    = "MIRACLE_ITEM"
		static let backButton     = "BACK_BUTTON"
		static let particleSystem = "PARTICLE_SYSTEM"
	}

	// back button's definitions
	struct UI_BACK_BUTTON {
		static let alias = "backButton"
		static let width = 45
	}

	// general audio config
	struct AUDIO_CFG {
		static let fileFormat            = "mp3"
		static let musicMenuSystem       = "menu"
		static let effectMatchingSuccess = "matchingSuccess"
		static let effectStageSuccess:[String] = [
			"stageSuccess0",
			"stageSuccess1",
			"stageSuccess2"
		]
	}

	// type of miracle items
    static let MIRACLE_ITEM_TYPE = [
		"notUsedType",
        "oneTime",
        "forever"
    ]

	// default config values used by the application to store settings
	// this will be used when starting the app after a new installation
    static let DEFAULT_APPLICATION_SETTINGS = [
        ["isMusicEnabled", 1],
        ["isSoundEffectsEnabled", 1],
        ["isAutoBabyModeEnabled", 0],
        ["isMiracleItemsEnabled", 1],
        ["selectedDifficulty", Defines.DIFFICULTY_LEVEL.medium.rawValue]
    ]

	// debug config
	struct DEBUG {
		static let showFpsOnGameScene       = false
		static let showNodeCountOnGameScene = false
	}
}
