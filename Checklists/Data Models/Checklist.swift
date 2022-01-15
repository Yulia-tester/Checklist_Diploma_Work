//
//  Checklist.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit

final class Checklist: Codable {
    var name: String
    var items: [ChecklistItem]
    var iconName: String

    init(name: String, iconName: String = "Без иконки") {
        self.name = name
        self.items = []
        self.iconName = iconName
    }

    func countUncheckedItems() -> Int {
        let count = items
            .filter { $0.checked == false }
            .count

        return count
    }
}
