//
//  ConfigModel.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation

// Configuration model file for handling key-value pairs for application settings
// Currently it uses NSUserDefaults as an engine
class ConfigModel {
    private let config = NSUserDefaults.standardUserDefaults()

    
    // storing settings permanently
    internal func save() {
        self.config.synchronize()
    }

    // returns with the value of a key
    internal func getValue(key: String) -> AnyObject {
        return self.config.valueForKey(key)!
    }

    // saves a value for a key
    internal func setValue(key: String, value: AnyObject?) {
        self.config.setValue(value, forKey: key)
    }

    // tells whether a key is present in the settings
    internal func isKeyExists(key: String) -> Bool {
        return !(self.config.objectForKey(key) == nil)
    }

}
