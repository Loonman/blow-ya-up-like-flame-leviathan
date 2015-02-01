//
//  SequnceGenerators.swift
//  Math
//
//  Created by David Skrundz on 2014-06-11.
//  Copyright (c) 2014 David Skrundz. All rights reserved.
//

/// Returns a function that returns the next integer each time it's called
public func newPositiveIntSequenceFrom(start: Int) -> () -> Int {
	var currentInt = start
	var generator = {() -> Int in
		return currentInt++
	}
	return generator
}