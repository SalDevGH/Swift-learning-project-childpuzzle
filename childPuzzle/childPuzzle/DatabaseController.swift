//
//  ConfigController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import UIKit
import SQLite

// Wrapper controller for SQLite database handling
class DatabaseController {
	// database instance
	internal var db:Connection?


	// creates a database connection and stores it when succeeded
	internal func setUpDatabaseConnection(sqlLiteFileName: String, sqlLiteFileExt: String) {
		// connecting to the database in read-only mode
		do {
			let path = NSBundle.mainBundle().pathForResource(sqlLiteFileName, ofType: sqlLiteFileExt)!
			self.db  = try Connection(path, readonly: true)
		} catch {
			print("Error happened while opening database")
		}
	}

	// returns with the database connection or nil if it is not exists
	internal func getDatabaseConnection() -> Connection? {
		return self.db
	}

}