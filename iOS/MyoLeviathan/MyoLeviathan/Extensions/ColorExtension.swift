//
//  ColorExtension.swift
//  Util
//
//  Created by David Skrundz on 2014-12-16.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

#if os(iOS)
	import UIKit
	public typealias Color = UIColor
#else
	import AppKit
	public typealias Color = NSColor
#endif

/// Adds flat colors
public extension Color {
	public class func flatPinkColor() -> Color {
		return Color(red: 206/255.0, green: 67/255.0, blue: 130/255.0, alpha: 1.0);
	}
	
	public class func flatYellowColor() -> Color {
		return Color(red: 253/255.0, green: 197/255.0, blue: 0.0, alpha: 1.0);
	}
	
	public class func flatOrangeColor() -> Color {
		return Color(red: 1.0, green: 167/255.0, blue: 28/255.0, alpha: 1.0);
	}
	
	public class func flatGreenColor() -> Color {
		return Color(red: 158/255.0, green: 211/255.0, blue: 15/255.0, alpha: 1.0);
	}
	
	public class func flatBlueColor() -> Color {
		return Color(red: 100/255.0, green: 194/255.0, blue: 227/255.0, alpha: 1.0);
	}
	
	public class func flatPurpleColor() -> Color {
		return Color(red: 124/255.0, green: 118/255.0, blue: 247/255.0, alpha: 1.0);
	}
}

/// Adds flat button colors
public extension Color {
	/// The button color class to manage different button styles
	public class ButtonColors {
		public let normalBackgroundImage: Image?
		public let highlightedBackgroundImage: Image?
		
		public let normalTextColor: Color?
		public let highlightedTextColor: Color?
		
		public let borderCGColor: CGColorRef?
		
		public init(bgColor: Color?, bgHighlightColor: Color?, textColor: Color?, textHighlightColor: Color?, borderColor: Color?) {
			if let bgC = bgColor {
				self.normalBackgroundImage = Image.imageFromColor(bgC)
			}
			if let bgHC = bgHighlightColor {
				self.highlightedBackgroundImage = Image.imageFromColor(bgHC)
			}
			self.normalTextColor = textColor
			self.highlightedTextColor = textHighlightColor
			if let bC = borderColor {
				self.borderCGColor = bC.CGColor
			}
		}
		
		public convenience init(bgColor: Color, bgHighlightColor: Color, textColor: Color, borderColor: Color) {
			self.init(bgColor: bgColor, bgHighlightColor: bgHighlightColor, textColor: textColor, textHighlightColor: textColor, borderColor: borderColor)
		}
	}
	
	public class func flatColorsDefault() -> ButtonColors {
		return ButtonColors(
			bgColor:			Color.whiteColor(),
			bgHighlightColor:	Color(red: 230/255.0,		green: 230/255.0,	blue: 230/255.0,	alpha: 1.0),
			textColor:			Color(red:  51/255.0,		green:  51/255.0,	blue:  51/255.0,	alpha: 1.0),
			textHighlightColor: Color(red:  77/255.0,		green:  51/255.0,	blue:  51/255.0,	alpha: 1.0),
			borderColor:		Color(red: 162/255.0,		green: 162/255.0,	blue: 162/255.0,	alpha: 1.0)
		)
	}
	
	public class func flatColorsPrimary() -> ButtonColors {
		return ButtonColors(
			bgColor:			Color(red:  70/255.0,		green: 138/255.0,	blue: 207/255.0,	alpha: 1.0),
			bgHighlightColor:	Color(red:  51/255.0,		green: 112/255.0,	blue: 173/255.0,	alpha: 1.0),
			textColor:			Color.whiteColor(),
			borderColor:		Color(red:  57/255.0,		green: 125/255.0,	blue: 194/255.0,	alpha: 1.0)
		)
	}
	
	public class func flatColorsSuccess() -> ButtonColors {
		return ButtonColors(
			bgColor:			Color(red: 102/255.0,		green: 184/255.0,	blue: 77/255.0,		alpha: 1.0),
			bgHighlightColor:	Color(red:  78/255.0,		green: 157/255.0,	blue: 51/255.0,		alpha: 1.0),
			textColor:			Color.whiteColor(),
			borderColor:		Color(red:  87/255.0,		green: 174/255.0,	blue: 58/255.0,		alpha: 1.0)
		)
	}
	
	public class func flatColorsInfo() -> ButtonColors {
		return ButtonColors(
			bgColor:			Color(red:  99/255.0,		green: 191/255.0,	blue: 225/255.0,	alpha: 1.0),
			bgHighlightColor:	Color(red:  63/255.0,		green: 175/255.0,	blue: 271/255.0,	alpha: 1.0),
			textColor:			Color.whiteColor(),
			borderColor:		Color(red:  80/255.0,		green: 183/255.0,	blue: 221/255.0,	alpha: 1.0)
		)
	}
	
	public class func flatColorsWarning() -> ButtonColors {
		return ButtonColors(
			bgColor:			Color(red: 238/255.0,		green: 174/255.0,	blue: 56/255.0,		alpha: 1.0),
			bgHighlightColor:	Color(red: 233/255.0,		green: 152/255.0,	blue:  0/255.0,		alpha: 1.0),
			textColor:			Color.whiteColor(),
			borderColor:		Color(red: 235/255.0,		green: 163/255.0,	blue:  4/255.0,		alpha: 1.0)
		)
	}
	
	public class func flatColorsDanger() -> ButtonColors {
		return ButtonColors(
			bgColor:			Color(red: 212/255.0,		green:  84/255.0,	blue:  76/255.0,	alpha: 1.0),
			bgHighlightColor:	Color(red: 193/255.0,		green:  49/255.0,	blue:  38/255.0,	alpha: 1.0),
			textColor:			Color.whiteColor(),
			borderColor:		Color(red: 199/255.0,		green:  63/255.0,	blue:  52/255.0,	alpha: 1.0)
		)
	}
}

/// Adds support for HEX colors
///
/// Supports:
///		#001122		(RGB)
///		#00112233	(RGBA)
///		#012		(RGB)
///		#0123		(RGBA)
public extension Color {
	public convenience init(HEXrgba: String) {
		var red:   CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue:  CGFloat = 0.0
		var alpha: CGFloat = 1.0
		
		if HEXrgba.hasPrefix("#") {
			let index   = advance(HEXrgba.startIndex, 1)
			let hex     = HEXrgba.substringFromIndex(index)
			let scanner = NSScanner(string: hex)
			var hexValue: CUnsignedLongLong = 0
			if scanner.scanHexLongLong(&hexValue) {
				switch (countElements(hex)) {
				case 3:
					red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
					green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
					blue  = CGFloat(hexValue & 0x00F)              / 15.0
					break
				case 4:
					red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
					green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
					blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
					alpha = CGFloat(hexValue & 0x000F)             / 15.0
					break
				case 6:
					red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
					green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
					blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
					break
				case 8:
					red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
					green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
					blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
					alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
					break
				default:
					println("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
					break
				}
			} else {
				println("Scan hex error")
			}
		} else {
			println("Invalid RGB string, missing '#' as prefix")
		}
		self.init(red:red, green:green, blue:blue, alpha:alpha)
	}
}