//
//  childPuzzleTests.swift
//  childPuzzleTests
//
//  Created by Gabor on 1/17/16.
//  Copyright © 2016 gsaliga. All rights reserved.
//

import XCTest
@testable import childPuzzle

class childPuzzleTests: XCTestCase {

	var matchingItemController:MatchingItemController?
	var matchingItemData:MatchingItemModel.matchingItemData?

	// called before the invocation of each test method in the class
    override func setUp() {
        super.setUp()

		self.matchingItemController = MatchingItemController()
		self.matchingItemData       = MatchingItemModel.matchingItemData(
			idPlayItem: 0,
			idStage: 1,
			alias: "",
			nodeName: "",
			width: 100.0,
			height: 100.0,
			winningPosition: CGPointMake(300, 300),
			startPosition: CGPointMake(0, 0),
			zPosition: 0,
			playable: true,
			userData: nil
		)
    }

	// called after the invocation of each test method in the class
    override func tearDown() {
		self.matchingItemController = nil
		self.matchingItemData       = nil

        super.tearDown()
    }

    // Testing if distance calculator is working correctly
    func testIsPositionNearEnoughToWin() {
		XCTAssertFalse(self.matchingItemController!.isPositionNearEnoughToWin(
			CGPointMake(-10, -10),
			itemData: self.matchingItemData!)
		)
		XCTAssertFalse(self.matchingItemController!.isPositionNearEnoughToWin(
			CGPointMake(100, 100),
			itemData: self.matchingItemData!)
		)
		XCTAssertTrue(self.matchingItemController!.isPositionNearEnoughToWin(
			CGPointMake(200, 200),
			itemData: self.matchingItemData!)
		)
		XCTAssertTrue(self.matchingItemController!.isPositionNearEnoughToWin(
			CGPointMake(300, 300),
			itemData: self.matchingItemData!)
		)
		XCTAssertTrue(self.matchingItemController!.isPositionNearEnoughToWin(
			CGPointMake(400, 400),
			itemData: self.matchingItemData!)
		)
		XCTAssertFalse(self.matchingItemController!.isPositionNearEnoughToWin(
			CGPointMake(500, 500),
			itemData: self.matchingItemData!)
		)
	}
	
}
