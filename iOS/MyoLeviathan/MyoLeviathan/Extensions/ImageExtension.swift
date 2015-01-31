//
//  ImageExtension.swift
//  Util
//
//  Created by David Skrundz on 2014-12-16.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

#if os(iOS)
	import UIKit
	public typealias Image = UIImage
#else
	import AppKit
	public typealias Image = NSImage
#endif

public extension Image {
	public class func imageFromColor(color: Color) -> Image {
		let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
		// Create the context
		#if os(iOS)
			UIGraphicsBeginImageContext(rect.size)
			let context: CGContext! = UIGraphicsGetCurrentContext()
		#else
			let returnImage = NSImage(size: NSSize(width: 1, height: 1))
			returnImage.lockFocus()
			let context: CGContext! = NSGraphicsContext.currentContext()?.CGContext
		#endif
		// Do the drawing
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, rect)
		// End the context
		#if os(iOS)
			let returnImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
		#else
			returnImage.unlockFocus()
		#endif
		return returnImage
	}
}