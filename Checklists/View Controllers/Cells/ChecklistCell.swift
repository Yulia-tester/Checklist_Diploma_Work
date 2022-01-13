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
    func cheklistCheckPressed(_ cell: ChecklistCell, itemData: ChecklistItem?)
}

final class ChecklistCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var button: UIButton!

    weak var delegate: ChecklistCellDelegate?
    var itemData: ChecklistItem? { didSet { setupCell() } }

    private func setupCell() {
        guard let data = itemData else { return }

        title.text = data.text
        button.isSelected = data.checked
    }

    @IBAction func checkPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        itemData?.checked = !sender.isSelected

        delegate?.cheklistCheckPressed(self, itemData: itemData)
    }

    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.cheklistEditPressed(self, itemData: itemData)
    }
}
