//
//  Application.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit
import SQLite

// Creating the one and only application object
var app = Application()

/* This class is intended to be the general manager of the application

What is it handles on top of the base class?
	- game state and related transition changes
	- music and sound effects except the gameplay effects
	- introduces auto-play feature
	- introduces miracle item handling
*/
class Application: SpriteKitGameBase {
	// all distinctly handled states of the application
	enum state:Int {
		case initApplication = -1, mainMenu, startingStage, playing, playingAutoBaby, finishingStage
	}

	// storage of current game state
	internal var currentGameState = state.initApplication

	// handling this property's setter differently than the base class does
	internal override var isMusicEnabled:Bool {
		get { return self.configController.isMusicEnabled }
		set {
			self.configController.isMusicEnabled = newValue
			self.handleMusicByCurrentState()
		}
	}
	internal var isMiracleItemsEnabled:Bool {
		get { return self.configController.isMiracleItemsEnabled }
		set { self.configController.isMiracleItemsEnabled = newValue }
	}
    internal var isAutoBabyModeEnabled:Bool {
        get { return self.configController.isAutoBabyModeEnabled }
        set { self.configController.isAutoBabyModeEnabled = newValue }
    }

    // getter for current game state
	internal func getGameState() -> state {
		return self.currentGameState
	}

	// setter for current game state, handles transition into a desired state
	internal func setGameState(newState: state) {
		// setting new state, performing related changes
		switch newState {
			case .initApplication:
				self.currentGameState = newState
				break

			// IN-MENU
			case .mainMenu:
				let statesRequiredToPresentMainMenu = [
					state.finishingStage,
					state.playing,
					state.playingAutoBaby
				]

				if statesRequiredToPresentMainMenu.contains(self.currentGameState) {
					if self.transitionController.getStageSelectionVC() == nil {
						self.transitionController.presentMainMenuFromGameScene()
					} else {
						self.transitionController.presentStageSelectionFromGameScene()
					}
				}

				self.currentGameState = newState
				break

			// STARTING A STAGE FROM STAGE SELECTION SCENE
			case .startingStage:
				// start presenting game scene after a while or instantly, to let the menu music fade-out if enabled
				let triggerTime = self.getMusicEnabled() ?
					(Int64(NSTimeInterval(NSEC_PER_SEC) * (Defines.TIMING.menuMusicFadeOut + 0.1))) :
				0

				self.currentGameState = newState

				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
					self.setGameState(.playing)
				})
				break

			// IN-PLAY: NORMAL
			case .playing:
				self.currentGameState = newState
				self.transitionController.presentGameSceneFromStageSelection()
				break

			// IN-PLAY: AUTO-BABY
			case .playingAutoBaby:
				let numStages     = self.stageController.getNumberOfStages()
				let oldState      = self.getGameState()
				var newStageIndex = 1

				// setting first or next stage to play with
				if (oldState != .initApplication) {
					let currentStage = self.getSelectedStageIndex()

					if currentStage + 1 <= numStages {
						newStageIndex = currentStage + 1
					}
				}
				self.setSelectedStageIndex(newStageIndex)

				// entering into new state
				self.currentGameState = newState

				// starting the very first or the next game
				if oldState == .initApplication {
					self.transitionController.presentGameSceneFromMainMenu()
				} else {
					// game scene is already present, so starting next stage immediately
					self.stageController.startStage()
				}
				break

			// GAME OVER: PLAYER JUST WON
			case .finishingStage:
				self.stageController.performFinale()
				self.currentGameState = newState

				// setting up state-change, which can be two ways: returning to the main menu, or keep playing in auto-baby mode
				let triggerTime = (Int64(NSTimeInterval(NSEC_PER_SEC) * NSTimeInterval(Defines.TIMING.sceneChange)))
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
					// unload current stage and move on
					self.stageController.endStage(false)
				})
				break
		}

		// dealing with music now
		self.handleMusicByCurrentState()
	}

	// handles music after entering a new game-state
	internal func handleMusicByCurrentState() {
		let soundControllerGame = self.stageController.getSoundControllerOfGame()

		switch self.currentGameState {
			case .playing,
				 .playingAutoBaby:

				// start selected stage's music
				if self.getMusicEnabled() {
					soundControllerGame.playMusic(
						self.stageController.getShortName(self.selectedStageIndex),
						fadeInDuration: Defines.TIMING.gameMusicFadeIn,
						loopForever: true
					)
				}
				break

			case .finishingStage:
				// fade-out music
				if self.getMusicEnabled() {
					soundControllerGame.startFadeOutMusic(NSTimeInterval(Defines.TIMING.gameMusicFadeOut))
				}

				// play stage-end sound effect
				if self.isSoundEffectsEnabled {
					let randomIndex = self.randInt(Defines.AUDIO_CFG.effectStageSuccess.count)
					soundControllerGame.playEffect(Defines.AUDIO_CFG.effectStageSuccess[randomIndex])
				}
				break

			case .mainMenu:
				if self.getMusicEnabled() {
					self.soundControllerMenu.playMusic(
						Defines.AUDIO_CFG.musicMenuSystem,
						fadeInDuration: Defines.TIMING.menuMusicFadeIn,
						loopForever: true
					)
				}
				break

			case .startingStage:
				if self.getMusicEnabled() {
					self.soundControllerMenu.startFadeOutMusic(NSTimeInterval(Defines.TIMING.menuMusicFadeOut))
				}
				break

			default: break
		}

		if !self.getMusicEnabled() {
			self.soundControllerMenu.stopMusic()
			soundControllerGame.stopMusic()
		}
	}

	// tells whether the game-scene is playable
	// it will give true only when the stage is yet presented AND the player already won it
	internal func isGameOver() -> Bool {
		return self.currentGameState == .finishingStage
	}

	// general method which should be called from all scenes if a memory warning is received
	internal override func handleMemoryWarning() {
		let statesConsideredPlaying = [
			state.finishingStage,
			state.playing,
			state.playingAutoBaby
		]

		if statesConsideredPlaying.contains(self.currentGameState) {
			self.stageController.endStage(true)
		} else {
			self.soundControllerMenu.stopMusic()
		}

		self.setMusicEnabled(false);
	}

	// getter for miracle items enabled
	internal func getMiracleItemsEnabled() -> Bool {
		return self.isMiracleItemsEnabled
	}

	// setter for miracle items enabled
	internal func setMiracleItemsEnabled(enabled: Bool) {
		self.isMiracleItemsEnabled = enabled
	}

	// getter for auto play enabled
	internal func getAutoPlayEnabled() -> Bool {
		return self.isAutoBabyModeEnabled
	}

	// setter for auto play enabled
	internal func setAutoPlayEnabled(enabled: Bool) {
		self.isAutoBabyModeEnabled = enabled
	}

}
