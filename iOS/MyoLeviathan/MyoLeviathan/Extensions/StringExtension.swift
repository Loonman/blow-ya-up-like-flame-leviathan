//
//  StringExtension.swift
//  Util
//
//  Created by David Skrundz on 2014-12-17.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// Helpers for string stuff
public extension String {
	/// Returns the length of the string in characters
	public var length: Int {
		return countElements(self)
	}
	
	/// Returns true if the string starts with the other string
	public func startsWith(string: String) -> Bool {
		if string.length <= self.length {
			return self.substringToIndex(advance(self.startIndex, string.length)) == string
		}
		return false
	}
	
	/// Returns true if the string ends with the other string
	public func endsWith(string: String) -> Bool {
		if string.length <= self.length {
			return self.substringFromIndex(advance(self.endIndex, -string.length)) == string
		}
		return false
	}
	
	/// Returns true if the strign contains the other string anywhere
	public func contains(string: String) -> Bool {
		return (self as NSString).containsString(string)
	}
	
	/// Returns a string of the single chosen character
	public subscript(index: Int) -> String {
		return self.substringWithRange(Range(start: self.startIndex + index, end: self.endIndex + index + 1))
	}
	
	/// Convert to [UInt8]
	public func toBytes() -> [UInt8] {
		var b = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)?.toBytes()
		if let bytes = b {
			return bytes
		}
		return []
	}
}

/// Allows for advancing the index a bit easier
public func +(left: String.Index, right: Int) -> String.Index {
	return advance(left, right)
}

/// Appends the right string to the left one by path component
public func /(left: String, right: String) -> String {
	return left.stringByAppendingPathComponent(right)
}