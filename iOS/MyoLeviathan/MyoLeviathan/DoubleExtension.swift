//
//  DoubleExtension.swift
//  Math
//
//  Created by David Skrundz on 2014-12-07.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

public extension Double {
	public var absolute: Double {
		get {
			if self >= 0 {
				return self
			} else {
				return -self
			}
		}
	}
}