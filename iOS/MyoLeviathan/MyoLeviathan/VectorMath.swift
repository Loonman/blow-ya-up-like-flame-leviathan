//
//  VectorMath.swift
//  Math
//
//  Created by David Skrundz on 2014-11-01.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

#if os(iOS)
	import UIKit
#else
	import AppKit
#endif

/// Returns the distance between the two points
public func PointDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
	return sqrt(pow(point1.x - point2.x, 2.0) + pow(point1.y - point2.y, 2.0))
}

/// Returns the angle between the two points. 0 is to the right and +Counter Clock Wise
public func PointDirection(point1: CGPoint, point2: CGPoint) -> Double {
	return atan2(Double(point2.y) - Double(point1.y), Double(point2.x) - Double(point1.x))
}

public func *(left: Double, right: CGPoint) -> CGPoint {
	return CGFloat(left) * right
}

public func *(left: CGFloat, right: CGPoint) -> CGPoint {
	return CGPointMake(left * right.x, left * right.y)
}

public func +(left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPointMake(left.x + right.x, left.y + right.y)
}

public func -(left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPointMake(left.x - right.x, left.y - right.y)
}

/// Dot product of two CGPoints as vectors
public func dot(left: CGPoint, right: CGPoint) -> CGFloat {
	return left.x * right.x + left.y * right.y
}