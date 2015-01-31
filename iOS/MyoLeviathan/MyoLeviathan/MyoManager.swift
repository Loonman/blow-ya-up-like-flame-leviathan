//
//  MyoManager.swift
//  MyoLeviathan
//
//  Created by David Skrundz on 2015-01-31.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation
import UIKit

class MyoManager {
	// Some stuff
	var callback: (() -> ())?
	
	// LOOP
	var statusTimer: Timer?
	var pollTimer: Timer?
	
	// MYO
	var myoConnected: Bool = false
	var myo: TLMMyo?
	
	var isSynced: Bool {
		get {
			return self.myo != nil
		}
	}
	
	init() {
		// MYO
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveArmSyncEventNotification:", name: TLMMyoDidReceiveArmSyncEventNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveArmUnsyncEventNotification:", name: TLMMyoDidReceiveArmUnsyncEventNotification, object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didConnectDeviceNotification:", name: TLMHubDidConnectDeviceNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "didDisconnectDeviceNotification:", name: TLMHubDidDisconnectDeviceNotification, object: nil)
	}
	
	// MARK: LOOP
	
	func initializeTimers() {
		self.invalidateTimers()
		self.statusTimer = Timer(seconds: 5.0, repeats: true, closure: { () -> () in
			// TODO:
		})
		self.statusTimer?.schedule()
		self.pollTimer = Timer(seconds: 0.1, repeats: true, closure: { () -> () in
			// TODO:
		})
		self.pollTimer?.schedule()
	}
	
	func invalidateTimers() {
		self.statusTimer?.invalidate()
		self.statusTimer = nil
		self.pollTimer?.invalidate()
		self.pollTimer = nil
	}
	
	// MARK: MYO
	func attachMyoProximity(callback: () -> ()) {
		self.callback = callback
		TLMHub.sharedHub().attachToAdjacent()
	}
	
	func disconnect() {
		TLMHub.sharedHub().detachFromMyo(self.myo)
	}
	
	// MARK: MYO NOTIFICATIONS
	
	@objc func didReceiveArmSyncEventNotification(notification: NSNotification) {
		if let event: TLMArmSyncEvent = notification.userInfo?[kTLMKeyArmSyncEvent] as? TLMArmSyncEvent {
			if self.myo == nil {
				// MYO
				self.myo = event.myo
				
				// LOOP
				self.initializeTimers()
			}
		}
	}
	
	@objc func didReceiveArmUnsyncEventNotification(notification: NSNotification) {
		if let event: TLMArmUnsyncEvent = notification.userInfo?[kTLMKeyArmUnsyncEvent] as? TLMArmUnsyncEvent {
			if event.myo == self.myo {
				// MYO
				self.myo = nil
				
				// LOOP
				self.invalidateTimers()
			}
		}
	}
	
	@objc func didConnectDeviceNotification(notification: NSNotification) {
		self.myoConnected = true
		self.callback?()
		self.callback = nil
	}
	
	@objc func didDisconnectDeviceNotification(notification: NSNotification) {
		self.myoConnected = false
		self.myo = nil
	}
}