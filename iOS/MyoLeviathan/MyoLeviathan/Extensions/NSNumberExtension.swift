//
//  NSNumberExtension.swift
//  Util_OSX
//
//  Created by David Skrundz on 2015-01-15.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

private let trueNumber = NSNumber(bool: true)
private let falseNumber = NSNumber(bool: false)
private let trueObjCType = String.fromCString(trueNumber.objCType)
private let falseObjCType = String.fromCString(falseNumber.objCType)

// MARK: - NSNumber: Comparable

/// Adds a check to see if an NSNumber is a Bool or not
public extension NSNumber {
	/// Is it a Bool?
	var isBool:Bool {
		get {
			let objCType = String.fromCString(self.objCType)
			if (self.compare(trueNumber) == NSComparisonResult.OrderedSame &&  objCType == trueObjCType) ||  (self.compare(falseNumber) == NSComparisonResult.OrderedSame && objCType == falseObjCType){
				return true
			} else {
				return false
			}
		}
	}
}

/// Compare NSNumbers
public func ==(lhs: NSNumber, rhs: NSNumber) -> Bool {
	switch (lhs.isBool, rhs.isBool) {
		case (false, true):
			return false
		case (true, false):
			return false
		default:
			return lhs.compare(rhs) == NSComparisonResult.OrderedSame
	}
}

/// Compare NSNumbers
public func !=(lhs: NSNumber, rhs: NSNumber) -> Bool {
	return !(lhs == rhs)
}

/// Compare NSNumbers
public func <(lhs: NSNumber, rhs: NSNumber) -> Bool {
	switch (lhs.isBool, rhs.isBool) {
		case (false, true):
			return false
		case (true, false):
			return false
		default:
			return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
	}
}

/// Compare NSNumbers
public func >(lhs: NSNumber, rhs: NSNumber) -> Bool {
	switch (lhs.isBool, rhs.isBool) {
		case (false, true):
			return false
		case (true, false):
			return false
		default:
			return lhs.compare(rhs) == NSComparisonResult.OrderedDescending
	}
}

/// Compare NSNumbers
public func <=(lhs: NSNumber, rhs: NSNumber) -> Bool {
	switch (lhs.isBool, rhs.isBool) {
		case (false, true):
			return false
		case (true, false):
			return false
		default:
			return lhs.compare(rhs) != NSComparisonResult.OrderedDescending
	}
}

/// Compare NSNumbers
public func >=(lhs: NSNumber, rhs: NSNumber) -> Bool {
	switch (lhs.isBool, rhs.isBool) {
		case (false, true):
			return false
		case (true, false):
			return false
		default:
			return lhs.compare(rhs) != NSComparisonResult.OrderedAscending
	}
}