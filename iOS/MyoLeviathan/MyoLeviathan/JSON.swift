//
//  JSON.swift
//  Util_OSX
//
//  Created by David Skrundz on 2015-01-15.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

///Error domain
public let ErrorDomain: String! = "JSONErrorDomain"

///Error codes
public let ErrorUnsupportedType: Int! = 999
public let ErrorIndexOutOfBounds: Int! = 900
public let ErrorWrongType: Int! = 901
public let ErrorNotExist: Int! = 500

/// The type that the JSON object contains
public enum Type: Int{
	case Number
	case String
	case Bool
	case Array
	case Dictionary
	case Null
	case Unknown
}

/// The JSON object. For decoding and for going through JSON strings
public struct JSON {
	private var _object: AnyObject = NSNull()
	private var type: Type = .Null
	private var error: NSError?
	
	/// Create a NULL JSON
	public init() {}
	
	/// Create a JSON from a String
	public init(json: String, error: NSErrorPointer) {
		if let data = json.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
			self.init(data: data, error: error)
			return
		}
		self.init(NSNull())
	}
	
	public init(data: NSData, error: NSErrorPointer) {
		if let obj: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: error) {
			self.init(obj)
			return
		}
		self.init(NSNull())
	}
	
	/// Create a JSON from an object
	public init(_ obj: AnyObject) {
		self.object = obj
	}
	
	/// The underlying object
	public var object: AnyObject {
		get {
			return self._object
		}
		set {
			self._object = newValue
			switch newValue {
				case let number as NSNumber:
					if number.isBool {
						self.type = .Bool
					} else {
						self.type = .Number
					}
				case let string as NSString:
					self.type = .String
				case let null as NSNull:
					self.type = .Null
				case let array as [AnyObject]:
					self.type = .Array
				case let dictionary as [String : AnyObject]:
					self.type = .Dictionary
				default:
					self.type = .Unknown
					_object = NSNull()
					self.error = NSError(domain: ErrorDomain, code: ErrorUnsupportedType, userInfo: [NSLocalizedDescriptionKey: "It is a unsupported type"])
			}
		}
	}
	
	/// Get from an Array at the index
	public subscript(index: Int) -> JSON {
		get {
			if self.type != .Array {
				var errorJSON = JSON()
				errorJSON.error = self.error ?? NSError(domain: ErrorDomain, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Array[\(index)] failure, It is not an array"])
				return errorJSON
			}
			let arr = self.object as [AnyObject]
			if index >= 0 && index < arr.count {
				return JSON(arr[index])
			}
			var errorJSON = JSON()
			errorJSON.error = self.error ?? NSError(domain: ErrorDomain, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Array[\(index)] is out of bounds"])
			return errorJSON
		}
		set {
			if self.type == .Array {
				var arr = self.object as [AnyObject]
				if index >= 0 && index < arr.count {
					arr[index] = newValue.object
					self.object = arr
				}
			}
		}
	}
	
	/// Get from a Dictionary at the key
	public subscript(key: String) -> JSON {
		get {
			if self.type == .Dictionary {
				if let obj: AnyObject = self.object[key] {
					return JSON(obj)
				} else {
					var errorJSON = JSON()
					errorJSON.error = self.error ?? NSError(domain: ErrorDomain, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Dictionary[\"\(key)\"] does not exist"])
					return errorJSON
				}
			}
			var errorJSON = JSON()
			errorJSON.error = self.error ?? NSError(domain: ErrorDomain, code: ErrorWrongType, userInfo: [NSLocalizedDescriptionKey: "Dictionary[\"\(key)\"] failure, It is not an dictionary"])
			return errorJSON
		}
		set {
			if self.type == .Dictionary {
				var dict = self.object as [String : AnyObject]
				dict[key] = newValue.object
				self.object = dict
			}
		}
	}
}

// MARK: - LiteralConvertible

/// Adds StringLiteralConvertible
extension JSON: StringLiteralConvertible {
	public init(stringLiteral value: StringLiteralType) {
		self.init(value)
	}
	
	public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
		self.init(value)
	}
	
	public init(unicodeScalarLiteral value: StringLiteralType) {
		self.init(value)
	}
}

/// Adds IntegerLiteralConvertible
extension JSON: IntegerLiteralConvertible {
	public init(integerLiteral value: IntegerLiteralType) {
		self.init(value)
	}
}

/// Adds BooleanLiteralConvertible
extension JSON: BooleanLiteralConvertible {
	public init(booleanLiteral value: BooleanLiteralType) {
		self.init(value)
	}
}

/// Adds FloatLiteralConvertible
extension JSON: FloatLiteralConvertible {
	public init(floatLiteral value: FloatLiteralType) {
		self.init(value)
	}
}

/// Adds DictionaryLiteralConvertible
extension JSON: DictionaryLiteralConvertible {
	public init(dictionaryLiteral elements: (String, AnyObject)...) {
		var dict = [String : AnyObject]()
		for (key, value) in elements {
			dict[key] = value
		}
		self.init(dict)
	}
}

/// Adds ArrayLiteralConvertible
extension JSON: ArrayLiteralConvertible {
	public init(arrayLiteral elements: AnyObject...) {
		self.init(elements)
	}
}

/// Adds NilLiteralConvertible
extension JSON: NilLiteralConvertible {
	public init(nilLiteral: ()) {
		self.init(NSNull())
	}
}

// MARK: - Raw

/// Adds RawRepresentable
extension JSON: RawRepresentable {
	public init?(rawValue: AnyObject) {
		if JSON(rawValue).type == .Unknown {
			return nil
		} else {
			self.init(rawValue)
		}
	}
	
	public var rawValue: AnyObject {
		return self.object
	}
	
	public func rawData(options opt: NSJSONWritingOptions = NSJSONWritingOptions(0), error: NSErrorPointer = nil) -> NSData? {
		return NSJSONSerialization.dataWithJSONObject(self.object, options: opt, error:error)
	}
	
	public func rawString(encoding: NSStringEncoding = NSUTF8StringEncoding, options opt: NSJSONWritingOptions = .PrettyPrinted) -> String? {
		switch self.type {
			case .Array, .Dictionary:
				if let data = self.rawData(options: opt) {
					return NSString(data: data, encoding: encoding)
				} else {
					return nil
				}
			case .String:
				return (self.object as String)
			case .Number:
				return (self.object as NSNumber).stringValue
			case .Bool:
				return (self.object as Bool).description
			case .Null:
				return "null"
			default:
				return nil
		}
	}
}

// MARK: - Printable, DebugPrintable

/// Adds Printable and DebugPrintable
extension JSON: Printable, DebugPrintable {
	public var description: String {
		if let string = self.rawString(options:.PrettyPrinted) {
			return string
		} else {
			return "unknown"
		}
	}
	
	public var debugDescription: String {
		return description
	}
}

// MARK: - Array

extension JSON {
	/// Optional [JSON]
	public var array: [JSON]? {
		get {
			if self.type == .Array {
				return map(self.object as [AnyObject]){ JSON($0) }
			} else {
				return nil
			}
		}
	}
	
	/// Non-optional [JSON]
	public var arrayValue: [JSON] {
		get {
			return self.array ?? []
		}
	}
	
	/// Optional [AnyObject]
	public var arrayObject: [AnyObject]? {
		get {
			switch self.type {
				case .Array:
					return self.object as? [AnyObject]
				default:
					return nil
			}
		}
		set {
			if newValue != nil {
				self.object = NSMutableArray(array: newValue!, copyItems: true)
			} else {
				self.object = NSNull()
			}
		}
	}
}

// MARK: - Dictionary

extension JSON {
	private func _map<Key:Hashable ,Value, NewValue>(source: [Key: Value], transform: Value -> NewValue) -> [Key: NewValue] {
		var result = [Key: NewValue](minimumCapacity:source.count)
		for (key,value) in source {
			result[key] = transform(value)
		}
		return result
	}
	
	/// Optional [String : JSON]
	public var dictionary: [String : JSON]? {
		get {
			if self.type == .Dictionary {
				return _map(self.object as [String : AnyObject]){ JSON($0) }
			} else {
				return nil
			}
		}
	}
	
	/// Non-optional [String : JSON]
	public var dictionaryValue: [String : JSON] {
		get {
			return self.dictionary ?? [:]
		}
	}
	
	/// Optional [String : AnyObject]
	public var dictionaryObject: [String : AnyObject]? {
		get {
			switch self.type {
				case .Dictionary:
					return self.object as? [String : AnyObject]
				default:
					return nil
			}
		}
		set {
			if newValue != nil {
				self.object = NSMutableDictionary(dictionary: newValue!, copyItems: true)
			} else {
				self.object = NSNull()
			}
		}
	}
}

// MARK: - Bool

extension JSON: BooleanType {
	/// Optional bool
	public var bool: Bool? {
		get {
			switch self.type {
				case .Bool:
					return self.object.boolValue
				default:
					return nil
			}
		}
		set {
			if newValue != nil {
				self.object = NSNumber(bool: newValue!)
			} else {
				self.object = NSNull()
			}
		}
	}
	
	/// Non-optional bool
	public var boolValue: Bool {
		get {
			switch self.type {
				case .Bool, .Number, .String:
					return self.object.boolValue
				default:
					return false
			}
		}
		set {
			self.object = NSNumber(bool: newValue)
		}
	}
}

// MARK: - String

extension JSON {
	/// Optional string
	public var string: String? {
		get {
			switch self.type {
				case .String:
					return self.object as? String
				default:
					return nil
			}
		}
		set {
			if newValue != nil {
				self.object = NSString(string:newValue!)
			} else {
				self.object = NSNull()
			}
		}
	}
	
	/// Non-optional string
	public var stringValue: String {
		get {
			switch self.type {
				case .String:
					return self.object as String
				case .Number:
					return self.object.stringValue
				case .Bool:
					return (self.object as Bool).description
				default:
					return ""
			}
		}
		set {
			self.object = NSString(string:newValue)
		}
	}
}

// MARK: - Number
extension JSON {
	/// Optional number
	public var number: NSNumber? {
		get {
			switch self.type {
				case .Number, .Bool:
					return self.object as? NSNumber
				default:
					return nil
			}
		}
		set {
			self.object = newValue?.copy() ?? NSNull()
		}
	}
	
	/// Non-optional number
	public var numberValue: NSNumber {
		get {
			switch self.type {
				case .String:
					let scanner = NSScanner(string: self.object as String)
					if scanner.scanDouble(nil){
						if (scanner.atEnd) {
							return NSNumber(double:(self.object as NSString).doubleValue)
						}
					}
					return NSNumber(double: 0.0)
				case .Number, .Bool:
					return self.object as NSNumber
				default:
					return NSNumber(double: 0.0)
			}
		}
		set {
			self.object = newValue.copy()
		}
	}
}

//MARK: - Null
extension JSON {
	/// NSNull
	public var null: NSNull? {
		get {
			switch self.type {
				case .Null:
					return NSNull()
				default:
					return nil
			}
		}
		set {
			self.object = NSNull()
		}
	}
}

//MARK: - URL
extension JSON {
	/// Optional URL
	public var URL: NSURL? {
		get {
			switch self.type {
				case .String:
					if let encodedString_ = self.object.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
						return NSURL(string: encodedString_)
					} else {
						return nil
					}
				default:
					return nil
			}
		}
		set {
			self.object = newValue?.absoluteString ?? NSNull()
		}
	}
}

// MARK: - Int, Double, Float, Int8, Int16, Int32, Int64

extension JSON {
	/// Optional Double
	public var double: Double? {
		get {
			return self.number?.doubleValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(double: newValue!)
			} else {
				self.object = NSNull()
			}
		}
	}
	
	/// Non-Optional Double
	public var doubleValue: Double {
		get {
			return self.numberValue.doubleValue
		}
		set {
			self.object = NSNumber(double: newValue)
		}
	}
	
	/// Optional Float
	public var float: Float? {
		get {
			return self.number?.floatValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(float: newValue!)
			} else {
				self.object = NSNull()
			}
		}
	}
	
	/// Non-Optional Float
	public var floatValue: Float {
		get {
			return self.numberValue.floatValue
		}
		set {
			self.object = NSNumber(float: newValue)
		}
	}
	
	/// Optional Int
	public var int: Int? {
		get {
			return self.number?.longValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(integer: newValue!)
			} else {
				self.object = NSNull()
			}
		}
	}
	
	/// Non-Optional Int
	public var intValue: Int {
		get {
			return self.numberValue.integerValue
		}
		set {
			self.object = NSNumber(integer: newValue)
		}
	}
	
	/// Optional UInt
	public var uInt: UInt? {
		get {
			return self.number?.unsignedLongValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(unsignedLong: newValue!)
			} else {
				self.object = NSNull()
			}
		}
	}
	
	/// Non-Optional UInt
	public var uIntValue: UInt {
		get {
			return self.numberValue.unsignedLongValue
		}
		set {
			self.object = NSNumber(unsignedLong: newValue)
		}
	}
	
	/// Optional Int8
	public var int8: Int8? {
		get {
			return self.number?.charValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(char: newValue!)
			} else {
				self.object =  NSNull()
			}
		}
	}
	
	/// Non-Optional Int8
	public var int8Value: Int8 {
		get {
			return self.numberValue.charValue
		}
		set {
			self.object = NSNumber(char: newValue)
		}
	}
	
	/// Optional UInt8
	public var uInt8: UInt8? {
		get {
			return self.number?.unsignedCharValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(unsignedChar: newValue!)
			} else {
				self.object =  NSNull()
			}
		}
	}
	
	/// Non-Optional UInt8
	public var uInt8Value: UInt8 {
		get {
			return self.numberValue.unsignedCharValue
		}
		set {
			self.object = NSNumber(unsignedChar: newValue)
		}
	}
	
	/// Optional Int16
	public var int16: Int16? {
		get {
			return self.number?.shortValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(short: newValue!)
			} else {
				self.object =  NSNull()
			}
		}
	}
	
	/// Non-Optional Int16
	public var int16Value: Int16 {
		get {
			return self.numberValue.shortValue
		}
		set {
			self.object = NSNumber(short: newValue)
		}
	}
	
	/// Optional UInt16
	public var uInt16: UInt16? {
		get {
			return self.number?.unsignedShortValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(unsignedShort: newValue!)
			} else {
				self.object =  NSNull()
			}
		}
	}
	
	/// Non-Optional UInt16
	public var uInt16Value: UInt16 {
		get {
			return self.numberValue.unsignedShortValue
		}
		set {
			self.object = NSNumber(unsignedShort: newValue)
		}
	}
	
	/// Optional Int32
	public var int32: Int32? {
		get {
			return self.number?.intValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(int: newValue!)
			} else {
				self.object =  NSNull()
			}
		}
	}
	
	/// Non-Optional Int32
	public var int32Value: Int32 {
		get {
			return self.numberValue.intValue
		}
		set {
			self.object = NSNumber(int: newValue)
		}
	}
	
	/// Optional UInt32
	public var uInt32: UInt32? {
		get {
			return self.number?.unsignedIntValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(unsignedInt: newValue!)
			} else {
				self.object =  NSNull()
			}
		}
	}
	
	/// Non-Optional UInt32
	public var uInt32Value: UInt32 {
		get {
			return self.numberValue.unsignedIntValue
		}
		set {
			self.object = NSNumber(unsignedInt: newValue)
		}
	}
	
	/// Optional Int64
	public var int64: Int64? {
		get {
			return self.number?.longLongValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(longLong: newValue!)
			} else {
				self.object =  NSNull()
			}
		}
	}
	
	/// Non-Optional Int64
	public var int64Value: Int64 {
		get {
			return self.numberValue.longLongValue
		}
		set {
			self.object = NSNumber(longLong: newValue)
		}
	}
	
	/// Optional UInt64
	public var uInt64: UInt64? {
		get {
			return self.number?.unsignedLongLongValue
		}
		set {
			if newValue != nil {
				self.object = NSNumber(unsignedLongLong: newValue!)
			} else {
				self.object =  NSNull()
			}
		}
	}
	
	/// Non-Optional UInt64
	public var uInt64Value: UInt64 {
		get {
			return self.numberValue.unsignedLongLongValue
		}
		set {
			self.object = NSNumber(unsignedLongLong: newValue)
		}
	}
}

//MARK: - Comparable
extension JSON: Comparable {}

public func ==(lhs: JSON, rhs: JSON) -> Bool {
	switch (lhs.type, rhs.type) {
		case (.Number, .Number):
			return (lhs.object as NSNumber) == (rhs.object as NSNumber)
		case (.String, .String):
			return (lhs.object as String) == (rhs.object as String)
		case (.Bool, .Bool):
			return (lhs.object as Bool) == (rhs.object as Bool)
		case (.Array, .Array):
			return (lhs.object as NSArray) == (rhs.object as NSArray)
		case (.Dictionary, .Dictionary):
			return (lhs.object as NSDictionary) == (rhs.object as NSDictionary)
		case (.Null, .Null):
			return true
		default:
			return false
	}
}

public func <=(lhs: JSON, rhs: JSON) -> Bool {
	switch (lhs.type, rhs.type) {
		case (.Number, .Number):
			return (lhs.object as NSNumber) <= (rhs.object as NSNumber)
		case (.String, .String):
			return (lhs.object as String) <= (rhs.object as String)
		case (.Bool, .Bool):
			return (lhs.object as Bool) == (rhs.object as Bool)
		case (.Array, .Array):
			return (lhs.object as NSArray) == (rhs.object as NSArray)
		case (.Dictionary, .Dictionary):
			return (lhs.object as NSDictionary) == (rhs.object as NSDictionary)
		case (.Null, .Null):
			return true
		default:
			return false
	}
}

public func >=(lhs: JSON, rhs: JSON) -> Bool {
	switch (lhs.type, rhs.type) {
		case (.Number, .Number):
			return (lhs.object as NSNumber) >= (rhs.object as NSNumber)
		case (.String, .String):
			return (lhs.object as String) >= (rhs.object as String)
		case (.Bool, .Bool):
			return (lhs.object as Bool) == (rhs.object as Bool)
		case (.Array, .Array):
			return (lhs.object as NSArray) == (rhs.object as NSArray)
		case (.Dictionary, .Dictionary):
			return (lhs.object as NSDictionary) == (rhs.object as NSDictionary)
		case (.Null, .Null):
			return true
		default:
			return false
	}
}

public func >(lhs: JSON, rhs: JSON) -> Bool {
	switch (lhs.type, rhs.type) {
		case (.Number, .Number):
			return (lhs.object as NSNumber) > (rhs.object as NSNumber)
		case (.String, .String):
			return (lhs.object as String) > (rhs.object as String)
		default:
			return false
	}
}

public func <(lhs: JSON, rhs: JSON) -> Bool {
	switch (lhs.type, rhs.type) {
		case (.Number, .Number):
			return (lhs.object as NSNumber) < (rhs.object as NSNumber)
		case (.String, .String):
			return (lhs.object as String) < (rhs.object as String)
		default:
			return false
	}
}