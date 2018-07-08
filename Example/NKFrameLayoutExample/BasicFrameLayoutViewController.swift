//
//  BasicFrameLayoutViewController.swift
//  NKFrameLayoutExample
//
//  Created by Nam Kennic on 7/8/18.
//  Copyright © 2018 kennic. All rights reserved.
//

import UIKit
import NKFrameLayoutKit

class BasicFrameLayoutViewController: UIViewController {
	
	let containerView = UIView()
	let label = UILabel()
	let codeTextView = UITextView()
	var frameLayout: NKFrameLayout!
	var mainFrameLayout: NKDoubleFrameLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Basic NKFrameLayout"
		self.view.backgroundColor = .gray
		self.edgesForExtendedLayout = []
		
		label.text = "Hello World"
		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = .blue
		
		codeTextView.textColor = .black
		codeTextView.font = UIFont(name: "Courier New", size: 14)
		codeTextView.textAlignment = .left
		codeTextView.backgroundColor = .white
		
		frameLayout = NKFrameLayout(targetView: label)
		frameLayout.showFrameDebug = true
		frameLayout.contentAlignment = "cc"
		
		containerView.backgroundColor = .white
		containerView.addSubview(label)
		containerView.addSubview(frameLayout)
		
		mainFrameLayout = NKDoubleFrameLayout(direction: .vertical, andViews: [containerView, codeTextView])
		mainFrameLayout.spacing = 10
		mainFrameLayout.topFrameLayout.heightRatio = 3/4
		mainFrameLayout.topFrameLayout.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		mainFrameLayout.bottomFrameLayout.edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		
		self.view.addSubview(containerView)
		self.view.addSubview(codeTextView)
		self.view.addSubview(mainFrameLayout)
		
		updateCode()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		mainFrameLayout.frame = self.view.bounds
		mainFrameLayout.setNeedsLayout()
		mainFrameLayout.layoutIfNeeded()
		
		frameLayout.frame = containerView.bounds
	}
	
	func updateCode() {
		let codeString =
		"""
		let layout = NKFrameLayout(targetView: label)
		layout.frame = self.bounds
		"""
		
		codeTextView.text = codeString
	}
}
