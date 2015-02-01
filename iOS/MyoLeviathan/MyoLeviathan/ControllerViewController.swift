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
	var timer2: Timer?
	var shouldHammer = true
	
	@IBOutlet var punchView: UIView?
	@IBOutlet var dotView: UIView?
	@IBOutlet var arrowView: UIView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let backButton = UIBarButtonItem(title: "Disconnect", style: UIBarButtonItemStyle.Bordered, target: self, action: "disconnect")
		self.navigationItem.leftBarButtonItem = backButton
		self.navigationItem.hidesBackButton = true
		
		self.connectionID = self.connectionManager.newConnection("192.168.1.100", port: 50_007, streamStyle: StreamFeed.Delimiter("\r\n"), delegate: self)
		if let myo = (UIApplication.sharedApplication().delegate as AppDelegate).myoManager.myo {
			myo.unlockWithType(TLMUnlockType.Hold)
		}
		
		self.timer2 = Timer(seconds: 0.1, repeats: true, closure: { () -> () in
			if let myo = (UIApplication.sharedApplication().delegate as AppDelegate).myoManager.myo {
				let angle = TLMEulerAngles(quaternion: myo.orientation.quaternion)
				
				self.arrowView?.transform = CGAffineTransformMakeScale(1.0, CGFloat(angle.pitch.radians) * -1.5)
				self.dotView?.transform = CGAffineTransformMakeRotation(CGFloat(angle.roll.radians * 2.0))
			}
		})
		
		self.timer = Timer(seconds: 0.4, repeats: true, closure: { () -> () in
			
			if let myo = (UIApplication.sharedApplication().delegate as AppDelegate).myoManager.myo {
				let angle = TLMEulerAngles(quaternion: myo.orientation.quaternion)
				
				let speed = max(-255, min(255, Int(angle.pitch.degrees * 255 / 45)))
				let turn = max(-20, min(20, Int(angle.roll.degrees * 30 / 20)))
				var hammer = false
				if let pose = myo.pose {
					if pose.type == TLMPoseType.Fist {
						if self.shouldHammer {
							hammer = true
							self.self.shouldHammer = false
							self.punchView?.hidden = false
						}
					} else {
						self.shouldHammer = true
						self.punchView?.hidden = true
					}
				}
				self.connectionManager.sendStringToConnection(self.connectionID, message: "\(Packets.packet(speed, turn: turn, hammer: hammer))\r\n")
			}
			
			if ((UIApplication.sharedApplication().delegate as AppDelegate).myoManager.myo?.state != TLMMyoConnectionState.Connected) {
				self.disconnect()
			}
		})
		self.timer?.schedule()
		self.timer2?.schedule()
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
		self.timer?.invalidate()
	}
	
	// MARK: ConnectionManagerDelegateProtocol
	
	func connectionStarted(connectionID: String) {
		// All good
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
}