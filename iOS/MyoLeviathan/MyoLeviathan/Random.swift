//
//  Random.swift
//  Util_OSX
//
//  Created by David Skrundz on 2015-01-08.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// Returns a random number between 0 and 1
public func random_0_1() -> Double {
	return Double(arc4random()) / Double(UINT32_MAX)
}

/// Returns a random number between -1 and 1
public func random__1_1() -> Double {
	return (2 * random_0_1()) - 1.0
}

/// Returns a random number between 0 and num (exclusively)
public func random_0_num(num: Double) -> Double {
	return random_0_1() * num
}

public func random_0_num(num: Int) -> Int {
	return Int(random_0_num(Double(num)))
}

/// Returns a random number between -num and num
public func random__num_num(num: Double) -> Double {
	return random__1_1() * num
}

/// Returns a random number between min and max
public func random_min_max(min: Double, max: Double) -> Double {
	return min + random_0_num(max - min)
}