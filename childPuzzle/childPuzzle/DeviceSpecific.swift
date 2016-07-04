//
//  DeviceInfo.swift
//  childPuzzle
//
//  Created by Gabor on 6/4/16.
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import SpriteKit

// configuration which describes the current device the application is running on
internal struct Device {
	private static let screenMaxLength = max(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)

	static let iPad      = UIDevice.currentDevice().userInterfaceIdiom == .Pad && screenMaxLength == 1024.0
	static let iPadLarge = UIDevice.currentDevice().userInterfaceIdiom == .Pad && screenMaxLength == 1366.0
	static let iPadAll   = iPad || iPadLarge
}

// configuration for resizing positions or sprite sizes on different scene sizes
internal struct DeviceAdjuster {
	static let iPad: CGFloat            = 1.3335
	static let iPadLarge: CGFloat       = 1
	static let iPadSprite: CGFloat      = 0.78
	static let iPadLargeSprite: CGFloat = 1.033
}

