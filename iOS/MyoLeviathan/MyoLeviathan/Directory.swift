//
//  Directory.swift
//  Util_OSX
//
//  Created by David Skrundz on 2015-01-20.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// Helps with some directory and file stuff
public class Directory {
//	#if os(iOS)
	
//	#else
	public class func userDirectories(directoryType: NSSearchPathDirectory) -> [String] {
		return (NSSearchPathForDirectoriesInDomains(directoryType, NSSearchPathDomainMask.UserDomainMask, true) as? [String]) ?? []
	}
	
	public class func fileExists(path: String) -> Bool {
		return NSFileManager.defaultManager().fileExistsAtPath(path)
	}
	
	public class func deleteFile(path: String) -> Bool {
		var error: NSError?
		NSFileManager.defaultManager().removeItemAtPath(path, error: &error)
		if let e = error {
			println("Could not delete item. Code: \(e.code), \(e.localizedDescription)")
			return false
		}
		return true
	}
	
	public class func moveFile(fromPath: String, toPath: String) -> Bool {
		var error: NSError?
		NSFileManager.defaultManager().moveItemAtPath(fromPath, toPath: toPath, error: &error)
		if let e = error {
			println("Could not move item. Code: \(e.code), \(e.localizedDescription)")
			return false
		}
		return true
	}
//	#endif
}