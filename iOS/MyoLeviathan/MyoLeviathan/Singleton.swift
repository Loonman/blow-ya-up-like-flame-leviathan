//
//  Singleton.swift
//  Util
//
//  Created by David Skrundz on 2014-12-09.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// The protocol for Singletons
public protocol SingletonProtocol: class {
	init()
	class func sharedInstance() -> Self
}

//public class Singleton: SingletonProtocol {
//	public required init() {}
//	
//	public class func sharedInstance() -> Self {
//		struct SingletonStruct {
//			static let instance = self()
//		}
//		return SingletonStruct.instance
//	}
//}

//public class Singleton: SingletonProtocol {
//	public required init() {}
//	
//	public class func sharedInstance() -> Self {
//		struct SingletonStruct {
//			static var onceToken: dispatch_once_t = 0
//			static var instance: protocol<SingletonProtocol>? = nil
//		}
//		dispatch_once(&SingletonStruct.onceToken, {
//			SingletonStruct.instance = self()
//		})
//		return SingletonStruct.instance!
//	}
//}