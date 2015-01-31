//
//  ArrayExtension.swift
//  Util_iOS
//
//  Created by David Skrundz on 2014-12-19.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// Removes the object from the array if it exists
public func removeObject<T: Equatable>(inout arr: Array<T>, object: T) -> T? {
	if let found = find(arr, object) {
		return arr.removeAtIndex(found)
	}
	return nil
}

/// Find the object
public func containsObject<T: Equatable>(inout arr: Array<T>, object: T) -> Bool {
	if let found = find(arr, object) {
		return true
	}
	return false
}

/// Allows creating an array of Int from a String
/// "[1,2,3]"
public func IntArrayFromString(var string: String) -> [Int] {
	var arr: [Int] = []
	string = string.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
	string = string.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.allZeros, range: nil)
	let strings: [String] = string.componentsSeparatedByString(",")
	for part in strings {
		let num = part.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		if let number = num.toInt() {
			arr += [number]
		}
	}
	return arr
}