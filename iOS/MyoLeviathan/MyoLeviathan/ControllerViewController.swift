//
//  ControllerViewController.swift
//  MyoLeviathan
//
//  Created by David Skrundz on 2015-01-31.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import UIKit

class ControllerViewController: UIViewController, ConnectionManagerDelegateProtocol {
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
	
	var timer: Timer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let backButton = UIBarButtonItem(title: "Disconnect", style: UIBarButtonItemStyle.Bordered, target: self, action: "disconnect")
		self.navigationItem.leftBarButtonItem = backButton
		self.navigationItem.hidesBackButton = true
		
		self.connectionID = self.connectionManager.newConnection("192.168.1.100", port: 50_007, streamStyle: StreamFeed.Delimiter("\r\n"), delegate: self)
		
		self.timer = Timer(seconds: 0.1, repeats: true, closure: { () -> () in
			if let orientation = (UIApplication.sharedApplication().delegate as AppDelegate).myoManager.myo?.orientation {
				self.connectionManager.sendStringToConnection(self.connectionID, message: "\(Packets.speedPacket(Int(orientation.quaternion.x * 1000.0)))\n")
			}
		})
		self.timer?.schedule()
	}
	
	let connectionManager = ConnectionManager()
	var connectionID: String!
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	@objc func disconnect() {
		self.connectionManager.closeConnections()
		(UIApplication.sharedApplication().delegate as AppDelegate).myoManager.disconnect()
		self.navigationController?.popToRootViewControllerAnimated(true)
	}
	
	// MARK: ConnectionManagerDelegateProtocol
	
	func connectionStarted(connectionID: String) {
		
	}
	
	func connectionError(connectionID: String, error: NSError) {
		UIAlertView(title: "Connection Error", message: "\(error)", delegate: nil, cancelButtonTitle: "OK").show()
		self.disconnect()
	}
	
	func connectionEnded(connectionID: String) {
		UIAlertView(title: "Connection Error", message: "Connection terminated by host", delegate: nil, cancelButtonTitle: "OK").show()
		self.disconnect()
	}
	
	func connectionReceivedData(connectionID: String, data: [UInt8]) {
		if let message = NSData(bytes: data, length: data.count).toString() {
			// TODO:
		}
	}
	
	@IBAction func a() {
		self.connectionManager.sendStringToConnection(self.connectionID, message: "\(Packets.speedPacket(255))")
	}
}