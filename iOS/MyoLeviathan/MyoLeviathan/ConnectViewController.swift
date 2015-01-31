//
//  ConnectViewController.swift
//  MyoLeviathan
//
//  Created by David Skrundz on 2015-01-31.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    override func viewDidLoad() { super.viewDidLoad() }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		appDelegate.myoManager.attachMyoProximity { () -> () in
			self.performSegueWithIdentifier("ToSync", sender: nil)
		}
	}
}