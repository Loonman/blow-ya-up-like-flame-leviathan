//
//  NSDataExtension.swift
//  Util
//
//  Created by David Skrundz on 2014-12-10.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

public extension NSData {
	public func toBytes() -> [UInt8] {
		var bytes = [UInt8](count: self.length, repeatedValue: 0)
		self.getBytes(&bytes)
		return bytes
	}
	
	public func toString() -> String? {
		return NSString(data: self, encoding: NSUTF8StringEncoding)
	}
}