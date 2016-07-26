//
//  ConfigController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import UIKit

// General basic key-value pair typed configuration handler
class ConfigController {
    private let model    = ConfigModel()
    private var autoSave = Bool()

	// configuration properties
	internal var isMusicEnabled:Bool {
		get { return self.getValue("isMusicEnabled") as! Bool }
		set { self.setValue("isMusicEnabled", value: newValue) }
	}
	internal var isSoundEffectsEnabled:Bool {
		get { return self.getValue("isSoundEffectsEnabled") as! Bool }
		set { self.setValue("isSoundEffectsEnabled", value: newValue) }
	}
	internal var isAutoBabyModeEnabled:Bool {
		get { return self.getValue("isAutoBabyModeEnabled") as! Bool }
		set { self.setValue("isAutoBabyModeEnabled", value: newValue) }
	}
	internal var isMiracleItemsEnabled:Bool {
		get { return self.getValue("isMiracleItemsEnabled") as! Bool }
		set { self.setValue("isMiracleItemsEnabled", value: newValue) }
	}
	internal var currentDifficultyLevel:Int {
		get { return self.getValue("selectedDifficulty") as! Int }
		set { self.setValue("selectedDifficulty", value: newValue) }
	}


    // constructor
    internal init(autoSave: Bool) {
        self.autoSave = autoSave
    }

    // returns with the value of a key
    internal func getValue(key: String) -> AnyObject {
        return self.model.getValue(key)
    }

    // saves a value for a key
    internal func setValue(key: String, value: AnyObject?) {
        self.model.setValue(key, value: value)

        if self.autoSave {
            self.save()
        }
    }

    // storing settings permanently
    internal func save() {
        self.model.save()
    }

    // ensuring all settings are present on the device
    internal func ensureAllSettingsArePresent() {
        for item in Defines.DEFAULT_APPLICATION_SETTINGS {
            let key = item[0] as! String

            if !self.model.isKeyExists(key) {
                self.setValue(key, value: item[1])
            }
        }
    }
    
}