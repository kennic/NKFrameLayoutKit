//
//  ContentTableViewController.swift
//  NKFrameLayoutExample
//
//  Created by Nam Kennic on 7/8/18.
//  Copyright © 2018 kennic. All rights reserved.
//

import UIKit

struct Section {
	var title: String
	var viewController: UIViewController.Type
}

class ContentTableViewController: UITableViewController {

	let CellIdentifier = "Cell"
	let sections: [Section] = [Section(title: "Basic NKFrameLayout", viewController: BasicFrameLayoutViewController.self)]
	
	var selectionBlock: ((Section) -> Void)? = nil
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "NKFrameLayoutKit Examples"
    }
	
    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
		
		if cell == nil {
			cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier)
			cell?.accessoryType = .disclosureIndicator
		}
		
		return cell!
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let section = sections[indexPath.row]
		cell.textLabel?.text = section.title
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let section = sections[indexPath.row]
		selectionBlock?(section)
	}

}
