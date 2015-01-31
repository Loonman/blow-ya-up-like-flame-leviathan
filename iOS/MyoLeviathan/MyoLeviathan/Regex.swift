//
//  Regex.swift
//  Util
//
//  Created by David Skrundz on 2014-12-17.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// Regex Matcher
///
/// http://www.regexr.com
public class Regex {
	private let expression: NSRegularExpression!
	
	/// Create a new Regex matcher from the String
	public init?(expression: String) {
		var error: NSError?
		self.expression = NSRegularExpression(pattern: expression, options: NSRegularExpressionOptions(0), error: &error)
		if self.expression == nil {
			if let err = error {
				Logger.logMessage(err.localizedDescription)
			}
			return nil
		}
	}
	
	/// Matches the string with the regex and returns a RegexMatch object
	public func match(string: String) -> RegexMatches {
		let matches = self.expression.matchesInString(string, options: NSMatchingOptions(0), range: NSRange(location: 0, length: string.length)) as [NSTextCheckingResult]
		return RegexMatches(string: string, matches: matches)
	}
}

/// Regex Matches
public class RegexMatches: CollectionType {
	private let string: String
	private let matches: [NSTextCheckingResult]
	
	private init(string: String, matches: [NSTextCheckingResult]) {
		self.string = string
		self.matches = matches
	}
	
	/// The number of matches
	public var matchCount: Int {
		return self.matches.count
	}
	
	public subscript(index: Int) -> RegexMatch {
		get {
			assert(index >= 0 && index < self.matchCount, "RegexMatches index out of range")
			return RegexMatch(string: self.string, match: self.matches[index])
		}
	}
	
	/// Required by CollectionType
	public func generate() -> GeneratorOf<RegexMatch> {
		var nextIndex = 0
		return GeneratorOf<RegexMatch> {
			if (nextIndex >= self.matchCount) {
				return nil
			}
			return self[nextIndex++]
		}
	}
	
	/// Required by CollectionType
	public var startIndex: Int {
		get {
			return 0
		}
	}
	
	/// Required by CollectionType
	public var endIndex: Int {
		get {
			return self.matchCount
		}
	}
}

/// A single match
public class RegexMatch: CollectionType {
	private let string: NSString
	private let match: NSTextCheckingResult
	
	private init(string: NSString, match: NSTextCheckingResult) {
		self.string = string
		self.match = match
	}
	
	public var count: Int {
		return self.match.numberOfRanges - 1
	}
	
	public subscript(index: Int) -> String {
		get {
			assert(index >= -1 && index < self.count, "RegexMatch index out of range")
			// Make sure something was in the group
			if self.match.rangeAtIndex(index + 1).location + self.match.rangeAtIndex(index + 1).length <= self.string.length {
				return self.string.substringWithRange(self.match.rangeAtIndex(index + 1))
			}
			// Nothing was found in the group, but the group was found
			return ""
		}
	}
	
	/// Required by CollectionType
	public func generate() -> GeneratorOf<String> {
		var nextIndex = 0
		return GeneratorOf<String> {
			if (nextIndex >= self.count - 1) {
				return nil
			}
			return self[nextIndex++]
		}
	}
	
	/// Required by CollectionType
	public var startIndex: Int {
		get {
			return 0
		}
	}
	
	/// Required by CollectionType
	public var endIndex: Int {
		get {
			return self.count
		}
	}
}