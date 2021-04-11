//
//  ListViewController.swift
//  FavsShareExtension
//
//  Created by yum on 2021/04/06.
//

import UIKit
import RealmSwift

@objc(ListViewControllerDelegate)
protocol ListViewControllerDelegate {
    @objc optional func listViewController(sender: ListViewController, selectedValue: FavCategory)
}

class ListViewController: UITableViewController {

    struct TableViewValues {
        static let identifier = "Cell"
    }

    var itemList: [FavCategory] = []
    var selectedValue: String = ""

    init(style: UITableView.Style, itemList: [FavCategory]) {
        super.init(style: style)
        self.itemList = itemList
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: TableViewValues.identifier)
        tableView.backgroundColor = UIColor.clear
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewValues.identifier, for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear

        let text: String = self.itemList[indexPath.row].displayName

        // 選択したアイテムにチェックマークをつける
        if text == selectedValue {
            cell.accessoryType = .checkmark
            cell.isSelected = true
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel!.text = text

        return cell
    }

    var delegate: ListViewControllerDelegate?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let theDelegate = delegate {
            theDelegate.listViewController!(sender: self, selectedValue: self.itemList[indexPath.row])
        }
    }
    
}
