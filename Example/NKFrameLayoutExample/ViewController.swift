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
	let testView = TestView()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.view.addSubview(testView)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let viewSize = self.view.bounds.size
		let testViewSize = testView.sizeThatFits(viewSize)
		
		// đưa testView vào giữa màn hình
		testView.frame = CGRect(x: (viewSize.width - testViewSize.width)/2, y: (viewSize.height - testViewSize.height)/2, width: testViewSize.width, height: testViewSize.height)
	}


}

/*
Class này hướng dẫn cách dùng NKDoubleFrameView để tạo layout cho 2 view bất kỳ theo chiều ngang hoặc dọc
Tóm tắt các bước khởi tạo:
- Tạo các view cần hiển thị trước, đưa chúng (addSubview:) vào view chính
- Khởi tạo NKDoubleFrameLayout với direction mong muốn (ngang hoặc dọc), kèm với 2 view cần layout
- Thay đổi thông số frameLayout nếu cần
- Đưa frameLayout vào view chính (addSubview:frameLayout)

Tương tự (sẽ update sau này) là NKTripleFrameLayout dùng để layout 3 view (ví dụ như cấu trúc: [Icon] [Text_Field] [Icon] )
Hoặc NKGridFrameLayout dùng để layout một mạng lưới không giới hạn các view
*/
class TestView: UIView {
	let label1 = UILabel()
	let label2 = UILabel()
	let label3 = UILabel()
	var frameLayout : NKDoubleFrameLayout!
	var gridFrameLayout : NKGridFrameLayout!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
		
		label1.backgroundColor = .yellow
		label2.backgroundColor = .red
		label3.backgroundColor = .blue
		
		label1.font = UIFont(name: "Helvetica", size: 30)
		label2.font = UIFont(name: "Helvetica", size: 15)
		label3.font = UIFont(name: "Helvetica", size: 30)
		
		label1.text = "NKDoubleFrameLayout"
		label2.text = "Dùng NKDoubleFrameLayout để layout 2 view bất kỳ theo chiều ngang (.horizontal) hoặc dọc (.vertical)"
		label2.numberOfLines = 0
		
		label3.text = "Dùng NKGridFrameLayout để multi layout"
		label3.numberOfLines = 0
		
		self.addSubview(label1)
		self.addSubview(label2)
		self.addSubview(label3)
		
		frameLayout = NKDoubleFrameLayout(direction: .horizontal, andViews: [label1, label2]) // khởi tạo layout theo chiều dọc, và gán vào 2 view label1 & label2. Thử thay đổi thành .horizontal để xem thay đổi ra sao
		frameLayout.leftFrameLayout.fixSize = CGSize(width: 120, height: 0)
		
		gridFrameLayout = NKGridFrameLayout(direction: .vertical, andViews: [label3]) // khởi tạo layout theo chiều dọc, và gán vào 2 view label1 & label2. Thử thay đổi thành .horizontal để xem thay đổi ra sao
		gridFrameLayout.add(frameLayout).fixSize = CGSize(width: 0, height: 120)
//		gridFrameLayout.fixSize = CGSize(width: 0, height: 320)
		gridFrameLayout.firstFrameLayout().fixSize = CGSize(width: 120, height: 200)
		
		/* // Hoặc cách khởi tạo từng dòng (có thể dùng để thay thế target view khác nếu cần)
		frameLayout = NKDoubleFrameLayout(direction: .vertical)
		frameLayout.topFrameLayout.targetView = label1; // gán label1 vào phần layout phía trên
		frameLayout.bottomFrameLayout.targetView = label2; // gán label2 vào phần layout phía dưới
		*/
		
		// các dòng dưới đây là ví dụ việc thay đổi các thông số
//		frameLayout.topFrameLayout.minSize = CGSize(width: 0, height: 80)		// set chiều cao tối thiểu của phần label1 phía trên là 80px (width:0 nghĩa là không set giá trị)
//		frameLayout.bottomFrameLayout.maxSize = CGSize(width: 0, height: 100)	// set chiều cao tối đa của phần label2 phía dưới là 100px
		
		frameLayout.spacing = 10.0 // khoảng trống giữa 2 view
		frameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) // thêm khoảng trống vào 4 cạnh xung quanh nếu cần
		
		gridFrameLayout.spacing = 10.0 // khoảng trống giữa 2 view
		gridFrameLayout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) // thêm khoảng trống vào 4 cạnh xung quanh nếu cần
		gridFrameLayout.showFrameDebug = true // hiển thị các gạch ranh giới để debug
		
		self.addSubview(gridFrameLayout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gridFrameLayout.frame = self.bounds
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return gridFrameLayout.sizeThatFits(size)
	}
	
}
