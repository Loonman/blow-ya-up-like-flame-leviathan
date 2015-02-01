//
//  Packets.swift
//  MyoLeviathan
//
//  Created by David Skrundz on 2015-01-31.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

class Packets {
	class func packet(speed: Int, turn: Int, hammer: Bool) -> String {
		var dict: [String : AnyObject] = [:]
		dict["speed"] = min(255, max(-255, speed))
		dict["steer"] = min(30, max(-30, turn))
		dict["aux"] = hammer
		var err: NSError?
		return NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: &err)!.toString()!
	}
}