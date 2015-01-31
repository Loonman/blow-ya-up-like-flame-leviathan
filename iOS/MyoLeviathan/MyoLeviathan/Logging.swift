//
//  Logging.swift
//  Util
//
//  Created by David Skrundz on 2014-12-10.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

private let kLoggerDefaultsKey: String = "kLoggerDefaultsKey"

/// The logging class
public class Logger {
	/// Primary function to simplify debugging by printing the file and line number
	public class func logMessage(message: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
		println("\(message)\nFile: \(file)\nFunction: \(function)\nLine: \(line)\n")
	}
	
	/// Loggs the message and also saves it so it can be retreived later
	///
	/// Leave log empty ("") for the default location
	public class func saveMessage(message: String, var log: String, file: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
		Logger.logMessage(message)
		if log.isEmpty {
			log = kLoggerDefaultsKey
		}
		NSUserDefaults.standardUserDefaults().setObject("\(Logger.getLog(log))\n\(message)", forKey: log)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
	
	/// Returns the logged messages
	///
	/// Leave log empty ("") for the default location
	public class func getLog(var log: String) -> String {
		if log.isEmpty {
			log = kLoggerDefaultsKey
		}
		return NSUserDefaults.standardUserDefaults().objectForKey(log) as NSString
	}
	
	/// Delete all log entries that are saved
	///
	/// Leave log empty ("") for the default location
	public class func clearLog(var log: String) {
		if log.isEmpty {
			log = kLoggerDefaultsKey
		}
		NSUserDefaults.standardUserDefaults().setObject(nil, forKey: log)
		NSUserDefaults.standardUserDefaults().synchronize()
	}
}