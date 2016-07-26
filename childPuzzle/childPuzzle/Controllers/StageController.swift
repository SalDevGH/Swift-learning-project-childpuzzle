//
//  StageController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

class StageController {
    private var model                  = StageModel()
    private var matchingItemController = MatchingItemController()
	private var miracleController      = MiracleItemController()
    private var frogMiracleController  = FrogMiracleController()
	private var catMiracleController   = CatMiracleController()
    private var bgController           = BackgroundController()
    private var soundController        = SoundController()

	// this constant defines an inner box within the scene bounds to have a
	// safe area to place matching items within it
	private static let safeMarginToPlaceItems:Int = 150

	// this percentage value will be used to calculate the position of the exit button
	private static let exitBtnMarginPct:CGFloat = 5

	// stores the currently selected matching items node's (no multitouch supported)
    private var selectedMatchingItem:SKSpriteNode?

	// stores the distance of the touch location from the center of the node
	private var touchDistanceFromNodeCenter:CGPoint?

    // holds the scene's width and height
    private var currentSceneBounds:CGSize?


    // 2nd pass init
    internal func start() {
		// init model
		self.model.readStagesFromDB()

		// load general sound effects
		if app.getSoundEffectsEnabled() {
			self.loadGeneralSoundEffects()
		}

        // starting gameplay controllers
        self.matchingItemController.start()
		self.miracleController.start()
		self.frogMiracleController.start()
		self.catMiracleController.start()
    }

	// loads and starts a stage, using the previously selected difficulty level
	// should be called from the game scene's viewDidLoad()
	internal func startStage() {
		// show nothing to be able to fade-in everything at once
		app.getScene()!.alpha = 0

		// load selected stage
		self.load(app.getSelectedStageIndex(), difficultyLevel: app.getCurrentDifficultyLevel())

		// fade in scene
		self.fadeInGameScene()
	}

	// un-load stage
	internal func endStage(forceToGoToMainMenu: Bool) {
		// ask stage controller to finish the stage
		self.unload()

		// prepare next stage if Auto-Baby feature is used
		if app.getAutoPlayEnabled() && !forceToGoToMainMenu {
			// re-setting auto-play game state to get a loop
			app.setGameState(.playingAutoBaby)
		} else {
			// going back to the menu
			app.setGameState(.mainMenu)
		}
	}

	// performs the finale which happens after all pieces matched, so the player just won
	internal func performFinale() {
		// prepare stage for the ending
		self.prepareStageFinale()

		// fade out scene
		self.fadeOutGameScene()
	}

    // starts the game on the desired stage with applying the selected difficulty
    internal func load(stageIndex: Int, difficultyLevel: Int) {
		// setup bounds to work within
		self.setSceneBounds(app.getScene()!.frame.size)

        // create and show the empty background (without the matching items)
        self.bgController.create("\(self.getShortName(stageIndex))Empty")

		// adding back (exit) button to be able to go back to the stage selection
		self.addExitButtonToStage()


        // load matching items by difficulty
        let matchingItemList = self.model.getMatchingItemsForStage(stageIndex)
        let playableItems    = self.getPlayableItems(matchingItemList, difficultyLevel: difficultyLevel)
        let unPlayableItems  = self.getUnPlayableItems(matchingItemList, playableItems: playableItems)

        // inserting items which should be played with
        for (_, var element) in playableItems.enumerate() {
            self.addMatchingItemToStage(true, data: &element)
        }

        // inserting unplayable items, positioning them right to the winning position
        for (_, var element) in unPlayableItems.enumerate() {
			self.addMatchingItemToStage(false, data: &element)
        }

        // load miracle items if they are enabled
        if app.getMiracleItemsEnabled() {
            let miracleItemList = self.model.getMiracleItemsForStage(stageIndex)

            // inserting items which should be played with
            for (_, var item) in miracleItemList.enumerate() {
                self.addMiracleItemToStage(&item)
            }
        }
    }

    // finishes a stage, and cleans-up
    internal func unload() {
        // stop music and effects
        self.soundController.stopMusic()
        self.soundController.stopAllEffects()

		// remove exit button
		self.removeExitButtonFromStage()

		// delete all nodes from the scene
		self.matchingItemController.removeAllNodes()

        // delete background
        self.bgController.destroy()
    }

    // tells whether the player has placed all the matching items firmly
    internal func isPlayerWon() -> Bool {
        let items = self.matchingItemController.getAllInstances()

        for (_, item) in items.enumerate() {
			// simply checking if the item is placed around it's winner place (so no exact check),
			// because the exact checking would likely fail on different scene sizes
			if !self.matchingItemController.isItemAboutInWinningPosition(item) {
                return false
            }
        }

        return true
    }

    // this method is intended to do some cleanup on the stage, in order to keep the application in one piece, 
    // by disallowing the player to do any unexpected while the finale is happening
    internal func prepareStageFinale() {
        // removing back button in order to let the finale happen smoothly
		self.removeExitButtonFromStage()

		// destroy old background
		self.bgController.destroy()

		// delete all nodes from the scene
		self.matchingItemController.removeAllNodes()

		// showing non-Empty background, to avoid flickering of some matched items when fading the scene out
		// bonus consequence is that the fade will only affect one node only
		self.bgController.create(self.getShortName(app.getSelectedStageIndex()))
    }

    // performs a miracle regarding to the selected (miracle-) node
	internal func performMiracle(node: SKSpriteNode) {
		let alias = self.miracleController.getAliasOfNode(node)

        switch (alias) {
            case "frog" :
                self.frogMiracleController.performMiracle(node, soundController: self.soundController)
                break

			case "cat" :
				self.catMiracleController.performMiracle(node, soundController: self.soundController)
				break

            default: break
        }
    }

    // called when a touch is just started to drag a matching item
    // setting selected node if it's a matching item and it's not placed well yet
	internal func onMatchingItemTouchBegan(node: SKSpriteNode, location: CGPoint) {
        // reset drag state
        self.touchDistanceFromNodeCenter = CGPointMake(0, 0)

		// make node as selected, prepare drag & drop
        if !self.matchingItemController.isItemAboutInWinningPosition(node) {
            self.selectedMatchingItem    = node
			self.touchDistanceFromNodeCenter = CGPoint(
				x: location.x - self.selectedMatchingItem!.position.x,
				y: location.y - self.selectedMatchingItem!.position.y
			)
			self.matchingItemController.setZPosition(
				self.selectedMatchingItem!,
				z: Defines.Z_INDEX_MAP.currentlyDraggedItem
			)
        }
    }

    // called when a touch is moved on the scene
    // if drag was happened before, repositioning selected object to it's new location
	internal func onTouchMoved(location: CGPoint) {
        // was there a matching item selected previously?
        if self.selectedMatchingItem == nil {
            return
        }

        self.matchingItemController.setPosition(
            self.selectedMatchingItem!,
            position: CGPoint(
				x: location.x - self.touchDistanceFromNodeCenter!.x,
				y: location.y - self.touchDistanceFromNodeCenter!.y
			)
        )

        // other fancy stuff can go here, not just the item-positioning
        // 
    }

    // called when a touch is finished after dragging a matching item
	internal func onMatchingItemTouchEnded() {
        // was there a matching item selected previously?
        if self.selectedMatchingItem == nil {
            return
        }

        // if the matching item is ABOUT in it's place
        if self.matchingItemController.isItemAboutInWinningPosition(self.selectedMatchingItem!) {
            // positioning firmly
            self.matchingItemController.setItemToWinningPosition(self.selectedMatchingItem!)

            // playing sound effect if enabled
            if app.getSoundEffectsEnabled() {
                self.soundController.playEffect(Defines.AUDIO_CFG.effectMatchingSuccess)
            }

            // checking if all items are well-placed, in order to realize if the game ended
            if self.isPlayerWon() {
                app.setGameState(Application.state.finishingStage)
            }
        } else {
            // matching failed
            self.matchingItemController.setZPosition(
				self.selectedMatchingItem!,
				z: Defines.Z_INDEX_MAP.items
			)
        }

        // reset drag state to original
        self.selectedMatchingItem = nil
    }

	// called when a touch is finished on a miracle item
	internal func onMiracleItemTouchEnded(node: SKSpriteNode) {
		// perform the selected miracle
		self.performMiracle(node)
	}

	// adds the back (exit) button to the scene
	internal func addExitButtonToStage() {
		let sceneBounds      = self.getSceneBounds()
		let itemController   = ItemController()
		let backButtonMargin = sceneBounds.width / 100 * StageController.exitBtnMarginPct
		let backButtonData   = ItemModel.itemData(
			alias:     Defines.UI_BACK_BUTTON.alias,
			nodeName:  Defines.SKNODE_NAME.backButton,
			width:     CGFloat(Defines.UI_BACK_BUTTON.width),
			height:    CGFloat(0), // won't matter
			zPosition: Defines.Z_INDEX_MAP.controlItems,
			userData:  nil
		)

		// create and add new node
		itemController.create(backButtonData, position: CGPointMake(
			backButtonMargin,
			sceneBounds.height - backButtonMargin
		))
	}

	// removes the back (exit) button from the scene
	internal func removeExitButtonFromStage() {
		let scene  = app.getScene()!
		let button = scene.childNodeWithName(Defines.SKNODE_NAME.backButton)

		if button != nil {
			scene.removeChildrenInArray([button!])
		}
	}

	// sets the currently used scene's bounds
	internal func setSceneBounds(size: CGSize) {
		self.currentSceneBounds = size
	}

    // returns with the currently used scene's bounds
    internal func getSceneBounds() -> CGSize {
        return self.currentSceneBounds!
    }

    // tells the short name of a stage by stage-index
    internal func getShortName(atIndex: Int) -> String {
		return self.model.getStageShortName(atIndex)
    }

    // tells the current number of playable stages
    internal func getNumberOfStages() -> Int {
        return self.model.getNumberOfStages()
    }

	// getter for the soundController
	internal func getSoundControllerOfGame() -> SoundController {
		return self.soundController
	}

	// runs a fade-in effect on the game scene if it is exists
	internal func fadeInGameScene() {
		app.getScene()?.runAction(SKAction.fadeInWithDuration(NSTimeInterval(Defines.TIMING.sceneFadeIn)))
	}

	// runs a fade-out effect on the game scene if it is exists
	internal func fadeOutGameScene() {
		app.getScene()?.runAction(SKAction.fadeOutWithDuration(NSTimeInterval(Defines.TIMING.sceneFadeOut)))
	}

	// (pre)-loads stage-related effects
	internal func loadGeneralSoundEffects() {
		self.soundController.loadEffect(Defines.AUDIO_CFG.effectMatchingSuccess)

		for (_, effectName) in Defines.AUDIO_CFG.effectStageSuccess.enumerate() {
			self.soundController.loadEffect(effectName)
		}
	}

	// adds a matching element to the stage
	// the playable argument controls the starting position of the created item to let the 
	// difficulty level settings work. 
	// if an item is not playable, it will be placed to its winning position by default
	private func addMatchingItemToStage(playable: Bool, inout data: MatchingItemModel.matchingItemData) {
		// re-calculate winning position for the actual device
		data.winningPosition = CGPointMake(
			CGFloat().convertForDevices(data.winningPosition.x),
			CGFloat().convertForDevices(data.winningPosition.y)
		);

		// guess a position if item will be a playable one
		if playable {
			data.startPosition = self.getValidRandomPlayablePosition(
				self.getSceneBounds(),
				itemData: data
			)
		} else {
			data.startPosition = data.winningPosition
		}

		// set up z-position
		data.zPosition = playable ? Defines.Z_INDEX_MAP.items : Defines.Z_INDEX_MAP.matchedItems

		// creating object
		self.matchingItemController.create(data, playable: playable)
	}

	// adds a matching element to the stage
	private func addMiracleItemToStage(inout data: MiracleItemModel.miracleItemData) {
		// convert position to place the item correctly on all devices
		data.startPosition = CGPointMake(
			CGFloat().convertForDevices(data.startPosition.x),
			CGFloat().convertForDevices(data.startPosition.y)
		)

		// add item to the scene with it's appropriate controller
		switch (data.alias) {
			case "frog" : self.frogMiracleController.create(data)
						  break
			case "cat" : self.catMiracleController.create(data)
						 break

			default: break
		}

		// load sound effect for this item
		self.soundController.loadEffect(data.alias)
	}

	// filters the allItems array by the difficulty settings, 
	// gives back a set of elements to have fun with those
	private func getPlayableItems(allItems: [MatchingItemModel.matchingItemData],
	                              difficultyLevel: Int) -> [MatchingItemModel.matchingItemData] {

		let itemListCount:Int = allItems.count
		var playableItems:[MatchingItemModel.matchingItemData] = []

		// decide on how many items will be playable
		let desiredCount:Int   = Int(round(CGFloat(itemListCount / (3 - difficultyLevel))))
		var indexesAdded:[Int] = []

		// adding the exact number of random elements from the whole list
		while playableItems.count < desiredCount {
			let randomIndex = app.randInt(itemListCount)

			if ((indexesAdded.indexOf(randomIndex)) == nil) {
				playableItems.append(allItems[randomIndex])
				indexesAdded.append(randomIndex)
			}
		}

		return playableItems
	}

	// returns with a set of items which are not selected for playing
	// it's basically a diff from the allItems and playableItems
	private func getUnPlayableItems(allItems: [MatchingItemModel.matchingItemData],
	                                playableItems: [MatchingItemModel.matchingItemData])
		-> [MatchingItemModel.matchingItemData] {

		var unPlayableItems:[MatchingItemModel.matchingItemData] = []

		// inserting items which shouldn't be played with
		for (_, element) in allItems.enumerate() {
			var foundInPlayable = false

			for (_, playableElement) in playableItems.enumerate() {
				if playableElement.idPlayItem == element.idPlayItem {
					foundInPlayable = true
				}
			}

			if !foundInPlayable {
				unPlayableItems.append(element)
			}
		}

		return unPlayableItems
	}

	// returns with a random and valid position for a playable item
	private func getValidRandomPlayablePosition(bounds: CGSize,
	                                            itemData: MatchingItemModel.matchingItemData) -> CGPoint {

		var startPosition = CGPointMake(0, 0)
		let safeMargin    = StageController.safeMarginToPlaceItems

		// guess a random position within safe bounds
		repeat {
			startPosition.x = CGFloat(
				app.randInt(Int(bounds.width - 2 * CGFloat(safeMargin))) + safeMargin
			)
			startPosition.y = CGFloat(
				app.randInt(Int(bounds.height - 2 * CGFloat(safeMargin))) + safeMargin
			)
		} while self.matchingItemController.isPositionNearEnoughToWin(startPosition, itemData: itemData)

		return startPosition
	}

}
