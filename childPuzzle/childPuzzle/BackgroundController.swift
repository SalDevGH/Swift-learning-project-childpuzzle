//
//  BackgroundController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// Deals with full-size background management in a given scene
class BackgroundController {
    private let model = BackgroundModel()

    // inserts a background node and displays a background image on it
    internal func create(imageNamed: String) {
        self.model.create(imageNamed)
    }

    // deletes a background
    internal func destroy() {
        self.model.destroy()
    }
}
