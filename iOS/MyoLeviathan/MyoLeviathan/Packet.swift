//
//  Packet.swift
//  Networking
//
//  Created by David Skrundz on 2014-12-10.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// A Class to help convert values to JSON strings to send over the network
public class Packet {
	private var values: [String : AnyObject] = [:]
	public let message: String
	
	/// Create a new class with the specified message/command
	public init(message: String) {
		self.message = message
	}
	
	/// Sets a value to the key
	public func setValue(value: AnyObject?, key: String) {
		if let val: AnyObject = value {
			self.values[key] = val
		} else {
			self.values.removeValueForKey(key)
		}
	}
	
	/// Get a value from the key
	public func getValue(key: String) -> AnyObject? {
		return self.values[key]
	}
	
	/// Generic getter for when the type is known
	public func get<T>(key: String) -> T? {
		return self.values[key] as? T
	}
	
	private func toJSONData() -> NSData {
		let dict: [String : AnyObject] = ["Message" : self.message, "Data" : self.values]
		var err: NSError?
		let jsonData: NSData? = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: &err)
		assert(jsonData != nil, "You messed up on the json data stuff")
		return jsonData!
	}
	
	public func toJSONBytes() -> [UInt8] {
		return self.toJSONData().toBytes()
	}
	
	public func toJSON() -> String {
		if let str = self.toJSONData().toString() {
			return str
		}
		return ""
	}
}