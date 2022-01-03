//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Yulia on 1/3/22.
//  Copyright © 2022 Distillery. All rights reserved.
//

import UIKit

protocol ListCellDelegate: AnyObject {
  func listCellEditPressed(_ cell: ChecklistItem, listData: Checklist?)
}

final class ChecklistItem: UITableViewCell {
  
  @IBOutlet weak var title2: UILabel!
  @IBOutlet weak var details2: UILabel!
  
  weak var delegate: ListCellDelegate?
  var listData: Checklist? { didSet { setupCell() } }
  
  private func setupCell() {
    guard let data = listData else { return }


    icon.image = UIImage(named: data.iconName)
    title.text = data.name
  }

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

 
@IBAction func editPressed(_ sender: UIButton) {
    delegate?.listCellEditPressed(self, listData: listData)
  }
}
@IBAction func editPressed(_ sender: UIButton) {
  delegate?.listCellEditPressed(self, listData: listData)
}
}

  
