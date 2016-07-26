//
//  SKSpriteNodeResize.swift
//  childPuzzle
//
//  Created by Gabor on 6/4/16.
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {

	// it allows to convert a sprite size into an appropriate size which will be good for the actual device
	func convertForDevices() {
		if Device.iPad {
			self.adjustSpriteSize(multiplier: DeviceAdjuster.iPadSprite)
		} else if Device.iPadLarge {
			self.adjustSpriteSize(multiplier: DeviceAdjuster.iPadLargeSprite)
		}
	}

	// changes the size of the sprite by applying a device-relevant multiplier value
	func adjustSpriteSize(multiplier multiplier: CGFloat) {
		self.size.width  = self.size.width * multiplier
		self.size.height = self.size.height * multiplier
	}

}