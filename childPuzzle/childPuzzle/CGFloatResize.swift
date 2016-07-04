//
//  CGFloatResize.swift
//  childPuzzle
//
//  Created by Gabor on 6/4/16.
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

extension CGFloat {

	// it allows to convert a location on the screen into an appropriate location which will be good for the actual device
	func convertForDevices(value: CGFloat) -> CGFloat {
		if Device.iPad {
			return value / DeviceAdjuster.iPad
		}
		else if Device.iPadLarge {
			return value / DeviceAdjuster.iPadLarge
		}
		else {
			return value
		}
	}
	
}