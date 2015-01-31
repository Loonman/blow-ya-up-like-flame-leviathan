//
//  Connection.swift
//  Networking
//
//  Created by David Skrundz on 2014-12-08.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

/// The protocol to implement in order to get events back from the connection
public protocol ConnectionManagerDelegateProtocol: class {
	/// Called when the connection is successfull
	func connectionStarted(connectionID: String)
	/// Called when the connection errors
	func connectionError(connectionID: String, error: NSError)
	/// Called when the connection is terminated
	func connectionEnded(connectionID: String)
	/// Called when the connection received some bytes (when StreamFeed.Continuous())
	func connectionReceivedData(connectionID: String, data: [UInt8])
}

/// The style in which data is sent back to the delegate
public enum StreamFeed {
	case Continuous()
	case Delimiter(String)
}

public let StreamFeedContinuous = StreamFeed.Continuous()
public let StreamFeedCR = StreamFeed.Delimiter("\n")
public let StreamFeedLF = StreamFeed.Delimiter("\r")
public let StreamFeedCRLF = StreamFeed.Delimiter("\n\r")
public let StreamFeedLFCR = StreamFeed.Delimiter("\r\n")

internal class Connection: NSObject, NSStreamDelegate {
	private var inputStream: NSInputStream!
	private var outputStream: NSOutputStream!
	
	private var readBuffer: String = ""
	private var writeBuffer: [UInt8] = []
	private var canWrite: Bool = false
	
	internal let connectionID: String
	internal let streamFeed: StreamFeed
	
	internal weak var delegate: ConnectionManagerDelegateProtocol?
	private weak var manager: ConnectionManager?
	
	internal init(manager: ConnectionManager, connectionID: String, streamStyle: StreamFeed) {
		self.manager = manager
		self.connectionID = connectionID
		self.streamFeed = streamStyle
	}
	
	internal func connect(host: String, port: Int) -> Bool {
		if self.isConnected() {
			self.disconnect()
		}
		if (host.isEmpty || port <= 0) {
			return false
		}
		// Attempt to connect
		var readStream: NSInputStream?
		var writeStream: NSOutputStream?
		NSStream.getStreamsToHostWithName(host, port: port, inputStream: &readStream, outputStream: &writeStream)
		if (readStream == nil || writeStream == nil) {
			return false
		}
		// Now we can guarantee that they will exist for the lifetime of the connection
		self.inputStream = readStream
		self.outputStream = writeStream
		// Everything went good so far so schedule in the loop
		self.inputStream.delegate = self
		self.outputStream.delegate = self
		self.inputStream.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
		self.outputStream.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
		self.inputStream.open()
		self.outputStream.open()
		return true
	}
	
	private func isConnected() -> Bool {
		return (self.inputStream != nil && self.outputStream != nil)
	}
	
	private func close() {
		self.manager?.closeConnection(self.connectionID)
	}
	
	internal func disconnect() {
		self.inputStream.delegate = nil
		self.inputStream.close()
		self.inputStream = nil
		self.outputStream.delegate = nil
		self.outputStream.close()
		self.outputStream = nil
	}
	
	internal func sendBytes(var bytes: [UInt8]) {
		if self.isConnected() {
			self.writeBuffer += bytes
			self.write()
		}
	}
	
	private func write() {
		if self.canWrite {
			if self.writeBuffer.count > 0 {
				let length = self.outputStream.write(&self.writeBuffer, maxLength: self.writeBuffer.count)
				if length == -1 {
					println("There was an error writing to the buffer")
				} else {
					self.writeBuffer.removeRange(0..<length)
				}
				self.canWrite = false
			}
		}
	}
	
	private let maxBytesReadPerCycle = 1024
	
	private func read() {
		var buffer: [UInt8] = [UInt8](count: maxBytesReadPerCycle, repeatedValue: 0)
		var length: Int = 0
		while self.inputStream.hasBytesAvailable {
			length = self.inputStream.read(&buffer, maxLength: maxBytesReadPerCycle)
			let data = Array(buffer[0..<length])
			switch self.streamFeed {
				case .Continuous():
					self.delegate?.connectionReceivedData(self.connectionID, data: data)
				case let .Delimiter(delimiter):
					// Accumulate the incoming bytes as a string
					if let incomingString = NSData(bytes: data, length: data.count).toString() {
						self.readBuffer += incomingString
					}
					// Look for the delimiter then pass each line one at a time
					while true {
						
						let location = (self.readBuffer as NSString).rangeOfString(delimiter) // <-- Length of 2
						if location.location == NSNotFound {
							break
						}
						let message: String = (self.readBuffer as NSString).substringToIndex(location.location)
						self.readBuffer = (self.readBuffer as NSString).substringFromIndex(location.location + 2) // <-- Length of 2
						self.delegate?.connectionReceivedData(self.connectionID, data: message.toBytes())
					}
			}
		}
	}
	
	// MARK: NSStreamDelegate
	
	internal func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
		switch eventCode {
			case NSStreamEvent.OpenCompleted:
				if aStream == self.outputStream {
					self.delegate?.connectionStarted(self.connectionID)
				}
			case NSStreamEvent.HasBytesAvailable:
				if aStream == self.inputStream {
					self.read()
				}
			case NSStreamEvent.HasSpaceAvailable:
				if aStream == self.outputStream {
					self.canWrite = true
					self.write()
				}
			case NSStreamEvent.ErrorOccurred:
				self.delegate?.connectionError(self.connectionID, error: aStream.streamError!)
				self.close()
			case NSStreamEvent.EndEncountered:
				self.delegate?.connectionEnded(self.connectionID)
				self.close()
			default:
				Logger.logMessage("")
		}
	}
}