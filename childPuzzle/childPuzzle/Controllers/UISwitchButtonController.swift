//
//  UISwitchButtonController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import UIKit

// General checkbox-imitating UIButton handler
// It uses the standard UIButton's selected property to store the state of the "checkbox"
class UISwitchButtonController {
	// structure for defining each state's image names
	private struct imageNameByState {
		var normal: String   = ""
		var selected: String = ""
	}

	// stored image names for each state
	private var usedImageNames:imageNameByState


    // constructor for setting up normal/selected images
    internal init(normal: String, selected: String) {
		self.usedImageNames = imageNameByState(
			normal: normal,
			selected: selected
		)
    }

    // sets background images of button for normal and selected states, and sets default value
    internal func setupSwitchButton(btn: UIButton, defaultValue: Bool) {
        btn.setBackgroundImage(UIImage(named: self.usedImageNames.normal), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: self.usedImageNames.selected), forState: .Selected)

        btn.selected = defaultValue
    }

    // tells whether the state of the switch is ON
    internal func isSwitchOn(btn: UIButton) -> Bool {
        return btn.selected
    }

    // event callback handler when a switch-button is pressed
    // saving state immediately into the configuration
    internal func buttonHasPressed(btn: UIButton) {
        btn.selected = !btn.selected
    }

}
