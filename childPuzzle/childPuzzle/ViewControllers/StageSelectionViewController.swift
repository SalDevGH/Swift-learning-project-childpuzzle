//
//  StageSelectionViewController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import UIKit

// Stage Selection Screen handler
class StageSelectionViewController: UIViewController {
    // tells if the next stage is selected yet
    private var isStageSelected = false

    // stage selection buttons
    @IBOutlet private weak var stage0Button: UIButton!
    @IBOutlet private weak var stage1Button: UIButton!
    @IBOutlet private weak var stage2Button: UIButton!
    @IBOutlet private weak var stage3Button: UIButton!

	
    // enable unwinding
    internal override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController,
                                                       withSender sender: AnyObject) -> Bool {
        if self.respondsToSelector(action) {
            return true
        }
        
        return false
    }

	// overridden viewDidAppear to enable stage selection over and over again
	internal override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		// (re-)enable stage selection
		self.isStageSelected = false
	}

    // kickstarting game
    private func startPlayingStage(stageIndex: Int) {
        if !self.isStageSelected { // prevent double-tapping
            self.isStageSelected = true

            app.getTransitionController().setStageSelectionVC(self)
            app.setSelectedStageIndex(stageIndex)

            // now start stage
            app.setGameState(Application.state.startingStage)
        }
    }

    // actions for button presses
    @IBAction private func stage0Pressed(sender: AnyObject) {
        self.startPlayingStage(1)
    }

    @IBAction private func stage1Pressed(sender: AnyObject) {
        self.startPlayingStage(2)
    }

    @IBAction private func stage2Pressed(sender: AnyObject) {
        self.startPlayingStage(3)
    }

    @IBAction private func stage3Pressed(sender: AnyObject) {
        self.startPlayingStage(4)
    }

	// action for unwind seque
	@IBAction private func prepareForUnwindToStageSelection(segue: UIStoryboardSegue) {
	}
}
