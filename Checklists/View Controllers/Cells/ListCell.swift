//
//  Cell.swift
//  Checklists
//
//  Created by Yulia on 12/29/21.
//  Copyright © 2021 Distillery. All rights reserved.
//

import UIKit

// Делегат редактирования ячейки
protocol ListCellDelegate: AnyObject {
    func editPressed(_ cell: ListCell, listData: Checklist?)
}

final class ListCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    
    weak var delegate: ListCellDelegate?
    var listData: Checklist? { didSet { setupCell() } }
    
    struct Constants {
        static let emptyText = "Нет пунктов"
        static let allDoneText = "Все сделано"
        static let remainingText = "осталось"
        
    }

    private func setupCell() {
        guard let data = listData else { return }
        
        icon.image = UIImage(named: data.iconName)
        title.text = data.name
        
        let count = data.countUncheckedItems()
        if data.items.count == 0 {
            details.text = Constants.emptyText
        } else {
            details.text = count == 0 ? Constants.allDoneText : "\(count) " + Constants.remainingText
        }
    }

    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.editPressed(self, listData: listData)
    }
}
