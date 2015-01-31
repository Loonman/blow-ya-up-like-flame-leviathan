//
//  Timer.swift
//  Util_OSX
//
//  Created by David Skrundz on 2015-01-23.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

public let nanoSecondsPerSecond = 1_000_000_000

public class Timer {
	/// The interval between calls in ms
	var timeInterval: UInt64
	var repeats: Bool
	var closure: (() -> ())?
	var queue: dispatch_queue_t!
	
	/// Create a new Timer
	public init(timeInterval: UInt64, queue: dispatch_queue_t!, repeats: Bool, closure: (() -> ())?) {
		self.timeInterval = timeInterval
		self.queue = queue
		self.repeats = repeats
		self.closure = closure
	}
	
	/// Create a new Timer
	public convenience init(timeInterval: UInt64, repeats: Bool, closure: (() -> ())?) {
		self.init(timeInterval: timeInterval, queue: dispatch_get_main_queue(), repeats: repeats, closure: closure)
	}
	
	/// Create a new Timer
	public convenience init(seconds: Double, repeats: Bool, closure: (() -> ())?) {
		self.init(timeInterval: UInt64(seconds * Double(nanoSecondsPerSecond)), queue: dispatch_get_main_queue(), repeats: repeats, closure: closure)
	}
	
	/// Create an empty Timer on the Main Queue. Other properties should be set before calling fire() or schedule()
	public convenience init() {
		self.init(timeInterval: 0, queue: dispatch_get_main_queue(), repeats: false, closure: nil)
	}
	//dispatch_after(timeInterval, queue, closure)
	
	/// Force the Timer to fire
	public func fire() {
		self.closure?()
	}
	
	/// Stops the Timer from firing also removes the closure
	public func invalidate() {
		self.repeats = false
		self.closure = nil
	}
	
	/// Schedule the timer to fire
	public func schedule() {
		dispatch_after(self.timeInterval, self.queue) { [weak self] () -> Void in
			self?.dispatchCallback()
			return
		}
	}
	
	// Callback from dispatch after
	private func dispatchCallback() {
		// Fire
		self.fire()
		// Reschedule if repeats is true
		if self.repeats {
			self.schedule()
		}
	}
}