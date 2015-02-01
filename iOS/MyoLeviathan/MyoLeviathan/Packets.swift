//
//  Packets.swift
//  MyoLeviathan
//
//  Created by David Skrundz on 2015-01-31.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

class Packets {
	class func speedPacket(speed: Int) -> String {
		let dict = ["speed" : max(-255, min(255, speed))]
		var err: NSError?
		return NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: &err)!.toString()!
	}
}