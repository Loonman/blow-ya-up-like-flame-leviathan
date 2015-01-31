//
//  ConnectionManager.swift
//  Networking
//
//  Created by David Skrundz on 2014-12-06.
//  Copyright (c) 2014 1342435 ALBERTA LTD. All rights reserved.
//

import Foundation

public class ConnectionManager {
	private var connections: [Connection] = []
	
	public init() {}
	
	deinit {
		// Close every connection
		for connectionID in self.connectionIDs() {
			self.closeConnection(connectionID)
		}
	}
	
	/// Creates a new connection to the Host on the Port and returns the ConnectionID
	public func newConnection(host: String, port: Int, streamStyle: StreamFeed, delegate: ConnectionManagerDelegateProtocol?) -> String {
		let connectionID: String = "\(host):\(port)"
		self.newConnection(host, port: port, streamStyle: streamStyle, delegate: delegate, connectionID: connectionID)
		return connectionID
	}
	
	/// Creates a new connection to the Host on the Port using ConnectionID (this will close the other connection if there is a conflict)
	public func newConnection(host: String, port: Int, streamStyle: StreamFeed, delegate: ConnectionManagerDelegateProtocol?, connectionID: String) {
		// Removes the old connection if it exists
		self.closeConnection(connectionID)
		// Create the new connection
		let newConnection = Connection(manager: self, connectionID: connectionID, streamStyle: streamStyle)
		newConnection.delegate = delegate
		self.connections += [newConnection]
		newConnection.connect(host, port: port)
	}
	
	/// Changes the delegate of the connection
	public func setConnectionDelegate(connectionID: String, newDelegate: ConnectionManagerDelegateProtocol?) {
		if let index = self.connectionIndexByID(connectionID) {
			self.connections[index].delegate = newDelegate
		}
	}
	
	/// Closes the connection
	public func closeConnection(connectionID: String) {
		if let index = self.connectionIndexByID(connectionID) {
			let connection = self.connections.removeAtIndex(index)
			connection.disconnect()
		}
	}
	
	/// Close all connections
	public func closeConnections() {
		while self.connections.count > 0 {
			let connection = self.connections.removeAtIndex(0)
			connection.disconnect()
		}
	}

	/// Sends the bytes to the connection and returns how many were sent
	public func sendDataToConnection(connectionID: String, data: [UInt8]) {
		if let index = self.connectionIndexByID(connectionID) {
			self.connections[index].sendBytes(data)
		}
	}

	/// Sends the string to the connection - Uses Lossy NSUTF8StringEncoding
	public func sendStringToConnection(connectionID: String, message: String) {
		if let index = self.connectionIndexByID(connectionID) {
			self.connections[index].sendBytes(message.toBytes())
		}
	}
	
	/// Returns the number of active connections
	public func numberOfConnections() -> Int {
		return self.connections.count
	}
	
	/// Returns a list of the connectionIDs
	public func connectionIDs() -> [String] {
		var list: [String] = []
		for connection in self.connections {
			list.append(connection.connectionID)
		}
		return list
	}
	
	private func connectionIndexByID(connectionID: String) -> Int? {
		var i = 0
		while i < self.connections.count {
			if self.connections[i].connectionID == connectionID {
				return i
			}
			++i
		}
		return nil
	}
}