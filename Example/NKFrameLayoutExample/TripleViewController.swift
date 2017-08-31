//
//  TripleViewController.swift
//  NKFrameLayoutKit
//
//  Created by DuongPH on 8/28/17.
//  Copyright © 2017 kennic. All rights reserved.
//

import UIKit
import NKFrameLayoutKit

class TripleViewController: UIViewController {
    var frameLayout : NKGridFrameLayout!
    
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

//        label1.numberOfLines = 0
        label1.backgroundColor = UIColor.lightGray
        label2.backgroundColor = UIColor.brown
        label3.backgroundColor = UIColor.darkGray
        
        label1.text = "label1label1"
        label2.text = "label2label2label2"
        label3.text = "label3"
        
        self.view.addSubview(label1)
        self.view.addSubview(label2)
        self.view.addSubview(label3)
//        label1.isHidden = true

        frameLayout = NKGridFrameLayout(direction: .vertical, andViews: [label1, label2, label3])
        frameLayout.spacing = 5.0
        frameLayout.edgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        frameLayout.showFrameDebug = true
        frameLayout.layoutAlignment = .bottom
//      frameLayout.intrinsicSizeEnabled = false
        view.addSubview(frameLayout)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let frameLayoutFrame = CGRect(x: 0.0, y: view.bounds.size.height/3, width: view.bounds.size.width, height: 300.0)
//        let frameLayoutSize = frameLayout.sizeThatFits(frameLayoutFrame.size)
//        frameLayout.frame = CGRect(x: frameLayoutFrame.origin.x, y: frameLayoutFrame.origin.y, width: frameLayoutSize.width, height: frameLayoutSize.height)
        frameLayout.frame = frameLayoutFrame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
