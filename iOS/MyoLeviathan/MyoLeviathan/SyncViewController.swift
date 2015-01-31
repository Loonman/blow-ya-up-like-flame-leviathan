//
//  SyncViewController.swift
//  MyoLeviathan
//
//  Created by David Skrundz on 2015-01-31.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import UIKit

class SyncViewController: UIViewController {
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.hidesBackButton = true
	}
	
	var timer: Timer?
	
	@IBOutlet var gifView: UIWebView?
	
	override func viewDidAppear(animated: Bool) {
		self.timer = Timer(seconds: 0.1, repeats: true, closure: { [weak self] () -> () in
			self?.check()
			return
		})
		self.timer?.schedule()
	}
	
	func check() {
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		if appDelegate.myoManager.isSynced {
			self.timer?.invalidate()
			self.performSegueWithIdentifier("ToController", sender: nil)
		}
	}
}