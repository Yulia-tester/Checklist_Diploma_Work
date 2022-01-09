//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Yulia on 1/3/22.
//  Copyright © 2022 Distillery. All rights reserved.
//

import UIKit

protocol ChecklistCellDelegate: AnyObject {
    func cheklistEditPressed(_ cell: ChecklistCell, itemData: ChecklistItem?)
}

final class ChecklistCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!

    weak var delegate: ChecklistCellDelegate?
    var itemData: ChecklistItem? { didSet { setupCell() } }

    private func setupCell() {
        guard let data = itemData else { return }

        title.text = data.text
        //    icon.image = UIImage(named: data.iconName)
        //    title.text = data.name
    }


  //тут
  @IBOutlet weak var checkBoxOutlet:UIButton!{
          didSet{
              checkBoxOutlet.setImage(UIImage(named:"unchecked"), for: .normal)
              checkBoxOutlet.setImage(UIImage(named:"checked"), for: .selected)
          }
      }
  
  @IBAction func checkbox(_ sender: UIButton){
          sender.checkboxAnimation {
              print("I'm done")
              //here you can also track the Checked, UnChecked state with sender.isSelected
              print(sender.isSelected)
              
          }
  }
  
  
  
    //@IBAction func checkmark(_ sender: UIButton) {
      
    //}
  /*
    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.cheklistEditPressed(self, itemData: itemData)
    }


    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        label.text = "\(item.itemID): \(item.text)"
    }

}
*/

}
