//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Yulia on 1/3/22.
//  Copyright © 2022 Distillery. All rights reserved.
//

import UIKit

// Делегат редактирования ячейки
// Делегат check/uncheck ячейки
protocol ChecklistCellDelegate: AnyObject {
    func editPressed(_ cell: ChecklistCell, itemData: ChecklistItem?)
    func checkPressed(_ cell: ChecklistCell, itemData: ChecklistItem?)
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

    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.editPressed(self, itemData: itemData)
    }

    @IBAction func checkPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        itemData?.checked = !sender.isSelected

        delegate?.checkPressed(self, itemData: itemData)
    }
}
