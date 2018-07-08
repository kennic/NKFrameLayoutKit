//
//  ViewController.swift
//  NKFrameLayoutExample
//
//  Created by Nam Kennic on 7/3/17.
//  Copyright © 2017 kennic. All rights reserved.
//

import UIKit
import NKFrameLayoutKit

class ViewController: UINavigationController {
	
    override func viewDidLoad() {
		super.viewDidLoad()
		
		let contentTableViewController = ContentTableViewController()
		contentTableViewController.selectionBlock = { [weak self] section in
			self?.pushViewController(section.viewController.init(), animated: true)
		}
		
		self.viewControllers = [contentTableViewController]
	}
	
}


