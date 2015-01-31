//
//  Reachability.swift
//  Networking
//
//  Created by David Skrundz on 2014-12-06.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation
import SystemConfiguration

// MARK: Helper from Apple - Thanks to https://github.com/Isuru-Nanayakkara/Swift-Reachability for porting to swift

/// A helper for determining if we are connected to the Internet
public class Reachability {
	/// The type of internet connectivity
	public enum ReachabilityType: Int {
		case NotConnected = 0
		case WiFi = 1
		/// iOS Only
		case Cell = 2
	}
	
	/// Returns how the device is connected to the Internet
	public class func isConnected() -> ReachabilityType {
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
			SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
		}
		
		var flags: SCNetworkReachabilityFlags = 0
		if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
			return ReachabilityType.NotConnected
		}
		
		let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
		var isWWAN = false
		
		#if os(iOS)
			isWWAN = (flags & UInt32(kSCNetworkReachabilityFlagsIsWWAN)) != 0
			if(isReachable && isWWAN){
			return ReachabilityType.Cell
			}
		#endif
		
		if(isReachable && !isWWAN){
			return ReachabilityType.WiFi
		}
		
		return ReachabilityType.NotConnected
	}
	
	private init() {} // Should never be called
}