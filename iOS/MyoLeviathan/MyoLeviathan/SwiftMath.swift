//
//  SwiftMath.swift
//  Math
//
//  Created by David Skrundz on 2014-11-18.
//  Copyright (c) 2014 DavidSkrundz. All rights reserved.
//

import Foundation

// Angle Conversions

/// Convert From Degrees
public func degreesToRadians(degrees: Double) -> Double { return (degrees * M_PI) / 180.0 }
public func degreesToGradians(degrees: Double) -> Double { return (degrees * 400.0) / 360.0 }

/// Convert From Radians
public func radiansToDegrees(radians: Double) -> Double { return (radians * 180.0) / M_PI }
public func radiansToGradians(radians: Double) -> Double { return (radians * 200.0) / M_PI }

/// Convert From Gradians
public func gradiansToDegrees(gradians: Double) -> Double { return (gradians * 360.0) / 400.0 }
public func gradiansToRadians(gradians: Double) -> Double { return (gradians * M_PI) / 200.0 }