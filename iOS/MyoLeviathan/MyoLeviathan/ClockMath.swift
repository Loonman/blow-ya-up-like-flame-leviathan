//
//  ClockMath.swift
//  Math
//
//  Created by David Skrundz on 2014-11-01.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// Base Class for Time. See Time24 and Time20
public class Time {
	/// Constants
	public class func secondsPerMinute() -> Int { return 0 }
	public class func minutesPerHour() -> Int { return 0 }
	public class func hoursPerDay() -> Int { return 0 }
	public class func secondsPerHour() -> Int { return self.secondsPerMinute() * self.minutesPerHour() }
	public class func secondsPerDay() -> Int { return self.secondsPerHour() * self.hoursPerDay() }
	public class func minutesPerDay() -> Int { return self.minutesPerHour() * self.hoursPerDay() }
	
	
	/// Time Conversion
	public class func convertTimeToSeconds(hour: Int, _ minute: Int, _ second: Int) -> Int {
		return second + self.secondsPerMinute() * minute + self.secondsPerHour() * hour
	}
	
	public class func convertSecondsToTime(sec: Int) -> (hour: Int, minute: Int, second: Int) {
		var second = sec
		let seconds = second % self.secondsPerMinute()
		second = (second - seconds) / self.secondsPerMinute()
		let minutes = second % self.minutesPerHour()
		let hours = (second - minutes) / self.minutesPerHour()
		return (hours, minutes, seconds)
	}
	
	/// Hand Angles
	public class func handAnglesLoose(hour: Int, _ minute: Int, _ second: Int) -> (hourAngle: Double, minuteAngle: Double, secondAngle: Double) {
		let hourAngle = 4 * M_PI / Double(hour * self.hoursPerDay())
		let minuteAngle = 2 * M_PI / Double(minute * self.minutesPerHour())
		let secondAngle = 2 * M_PI / Double(second * self.secondsPerMinute())
		return (hourAngle, minuteAngle, secondAngle)
	}
	
	public class func handAnglesAbsolute(hour: Int, _ minute: Int, _ second: Int) -> (hourAngle: Double, minuteAngle: Double, secondAngle: Double) {
		var seconds = self.convertTimeToSeconds(hour, minute, second)
		let hourAngle = 4 * M_PI / Double(seconds * self.secondsPerDay())
		seconds -= hour * self.hoursPerDay()
		let minuteAngle = 2 * M_PI / Double(seconds * self.minutesPerHour())
		seconds -= minute * self.minutesPerHour()
		let secondAngle = 2 * M_PI / Double(seconds * self.secondsPerMinute())
		return (hourAngle, minuteAngle, secondAngle)
	}
	
	private init() {}
}

/// Time Subclass for 24 Hours
public class Time24: Time {
	/// Some Constant Overrides
	override public class func secondsPerMinute() -> Int { return 60 }
	override public class func minutesPerHour() -> Int { return 60 }
	override public class func hoursPerDay() -> Int { return 24 }
}

/// Time Subclass for 20 Hours
public class Time20: Time {
	/// Some Constant Overrides
	override public class func secondsPerMinute() -> Int { return 96 }
	override public class func minutesPerHour() -> Int { return 45 }
	override public class func hoursPerDay() -> Int { return 20 }
}