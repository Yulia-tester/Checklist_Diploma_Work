//
//  Cell.swift
//  Checklists
//
//  Created by Yulia on 12/29/21.
//  Copyright © 2021 Distillery. All rights reserved.
//

import UIKit

protocol ListCellDelegate: AnyObject {
  func listCellEditPressed(_ cell: ListCell, listData: Checklist?)
}

final class ListCell: UITableViewCell {
  
  
  @IBOutlet weak var icon: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var details: UILabel!

  weak var delegate: ListCellDelegate?
  var listData: Checklist? { didSet { setupCell() } }

  private func setupCell() {
    guard let data = listData else { return }


    icon.image = UIImage(named: data.iconName)
    title.text = data.name
  }

  //    cell.textLabel!.text = checklist.name
  //    cell.accessoryType = .detailDisclosureButton
  //    let count = checklist.countUncheckedItems()
  //    if checklist.items.count == 0 {
  //      cell.detailTextLabel!.text = Constants.emptyText
  //    } else {
  //      cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
  //    }
  //    cell.imageView!.image = UIImage(named: checklist.iconName)

  @IBAction func editPressed(_ sender: UIButton) {
    delegate?.listCellEditPressed(self, listData: listData)
  }
}
