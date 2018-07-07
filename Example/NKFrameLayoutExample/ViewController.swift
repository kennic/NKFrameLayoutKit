//
//  ViewController.swift
//  NKFrameLayoutExample
//
//  Created by Nam Kennic on 7/3/17.
//  Copyright © 2017 kennic. All rights reserved.
//

import UIKit
import NKFrameLayoutKit

class ViewController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "earth_48x48"))
    let label = UILabel()
    var frameLayout: NKDoubleFrameLayout!
	
    override func viewDidLoad() {
		super.viewDidLoad()
        
        label.text = "Hello World"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)
        
        frameLayout = NKDoubleFrameLayout(direction: .horizontal, andViews: [imageView, label])
        frameLayout.spacing = 10
        frameLayout.intrinsicSizeEnabled = true // return intrinsic width in sizeThatFits function
        frameLayout.showFrameDebug = true // show debug lines
		
        self.view.addSubview(imageView)
        self.view.addSubview(label)
        self.view.addSubview(frameLayout)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
        let viewSize = self.view.bounds.size
        let contentSize = frameLayout.sizeThatFits(viewSize)
        frameLayout.frame = CGRect(x: (viewSize.width - contentSize.width)/2, y: (viewSize.height - contentSize.height)/2, width: contentSize.width, height: contentSize.height)
	}
	
}


