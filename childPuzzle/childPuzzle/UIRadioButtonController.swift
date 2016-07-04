//
//  UIRadioButtonController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import UIKit

// General radiobox-imitating UIButton handler
// This class represents one radio-group
class UIRadioButtonController {
    // container of all elements
    private var elementContainer = [UIButton]()


    // event callback handler when a radio-button element (UIButton) is pressed
    internal func buttonHasPressed(btn: UIButton) {
        let index = self.getIndexByElement(btn)

        if index >= 0 {
            self.setSelectedElement(index)
        }
    }

    // adds a new element to the group, sets up images, and returns with it's index number
    internal func addElement(btn: UIButton, normal: String, selected: String) -> Int {
        self.setupElementImages(btn, normal: normal, selected: selected)
        self.elementContainer.append(btn)

        return self.elementContainer.count - 1
    }

    // removes references to all elements added
    internal func removeAllElement() {
        self.elementContainer.removeAll()
    }

    // returns with the currently selected element. If not found, the return value will be -1
    // precondition is that only one element is set as selected at a time
    internal func getSelectedElement() -> Int {
        var index = -1

        for i in 0 ..< self.elementContainer.count {
            if self.elementContainer[i].selected == true {
                index = i
            }
        }

        return index
    }
    
    // sets the given element by index as selected, and sets non-selected for all other elements
    internal func setSelectedElement(index: Int) {
        for obj in self.elementContainer {
            if self.elementContainer[index] != obj {
                obj.selected = false
            } else {
                obj.selected = true
            }
        }
    }

    // returns with the given element's index number. If not found, the return value will be -1
    internal func getIndexByElement(btn: UIButton) -> Int {
        for i in 0 ..< self.elementContainer.count {
            if self.elementContainer[i] == btn {
                return i
            }
        }

        return -1
    }

    // accessor method to set up a button's selected, normal and highlighted state related images
    // with using this function, it is possible to have separate background image for each radio-button
    internal func setupElementImages(btn: UIButton, normal: String, selected: String) {
        btn.setBackgroundImage(UIImage(named: normal), forState: .Normal)
        btn.setBackgroundImage(UIImage(named: selected), forState: .Selected)
    }

}

