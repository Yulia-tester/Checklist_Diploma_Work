//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Yulia on 1/3/22.
//  Copyright © 2022 Distillery. All rights reserved.
//

import UIKit

protocol ChecklistCellDelegate: AnyObject {
  func listCellEditPressed(_ cell: ChecklistCell, itemData: ChecklistItem?)
}

final class ChecklistCell: UITableViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var details: UILabel!
  
  weak var delegate: ChecklistCellDelegate?
  var itemData: ChecklistItem? { didSet { setupCell() } }
  
  private func setupCell() {
    guard let data = itemData else { return }

//    icon.image = UIImage(named: data.iconName)
//    title.text = data.name
  }

 
//@IBAction func editPressed(_ sender: UIButton) {
//    delegate?.listCellEditPressed(self, listData: listData)
//  }
//}
//@IBAction func editPressed(_ sender: UIButton) {
//  delegate?.listCellEditPressed(self, listData: listData)
//}

    //  func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    //    let label = cell.viewWithTag(1001) as! UILabel
    //    if item.checked {
    //      label.text = "√"
    //    } else {
    //      label.text = ""
    //    }
    //  }
    //
    //  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    //    let label = cell.viewWithTag(1000) as! UILabel
    //    label.text = item.text
    ////    label.text = "\(item.itemID): \(item.text)"
    //  }

}
