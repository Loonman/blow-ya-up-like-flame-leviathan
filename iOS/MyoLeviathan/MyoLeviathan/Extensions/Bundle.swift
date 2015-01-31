//
//  Bundle.swift
//  Util_OSX
//
//  Created by David Skrundz on 2015-01-19.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

public class Bundle {
	public class func applicationName() -> String {
		if let name = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String {
			return name
		}
		return ""
	}
}