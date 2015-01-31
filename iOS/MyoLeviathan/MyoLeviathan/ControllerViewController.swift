//
//  ControllerViewController.swift
//  MyoLeviathan
//
//  Created by David Skrundz on 2015-01-31.
//  Copyright (c) 2015 1342435 ALBERTA LTD. All rights reserved.
//

import UIKit

class ControllerViewController: UIViewController {
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let backButton = UIBarButtonItem(title: "Disconnect", style: UIBarButtonItemStyle.Bordered, target: self, action: "disconnect")
		self.navigationItem.leftBarButtonItem = backButton
		self.navigationItem.hidesBackButton = true
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		//
	}
	
	@objc func disconnect() {
		(UIApplication.sharedApplication().delegate as AppDelegate).myoManager.disconnect()
		self.navigationController?.popToRootViewControllerAnimated(true)
	}
}