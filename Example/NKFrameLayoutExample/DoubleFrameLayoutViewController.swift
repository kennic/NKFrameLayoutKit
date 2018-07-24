//
//  DoubleFrameLayoutViewController.swift
//  NKFrameLayoutExample
//
//  Created by Nam Kennic on 7/18/18.
//  Copyright © 2018 kennic. All rights reserved.
//

import UIKit
import NKFrameLayoutKit

class DoubleFrameLayoutViewController: UIViewController {
	let label = UILabel()
	let imageView = UIImageView(image: #imageLiteral(resourceName: "earth_48x48"))
	var frameLayout: NKDoubleFrameLayout!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "NKDoubleFrameLayout"
		self.view.backgroundColor = .gray
		self.edgesForExtendedLayout = []
		
		label.text = "Hello World"
		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = .red
		label.font = UIFont.systemFont(ofSize: 20)
		
		frameLayout = NKDoubleFrameLayout(direction: .horizontal, andViews: [imageView, label])
		frameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
		frameLayout.showFrameDebug = true
		frameLayout.spacing = 5
		frameLayout.intrinsicSizeEnabled = true
		
		view.addSubview(label)
		view.addSubview(imageView)
		view.addSubview(frameLayout)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let viewSize = self.view.bounds.size
		let contentSize = frameLayout.sizeThatFits(viewSize)
		frameLayout.frame = CGRect(x: (viewSize.width - contentSize.width)/2, y: (viewSize.height - contentSize.height)/2, width: contentSize.width, height: contentSize.height)
	}

}
