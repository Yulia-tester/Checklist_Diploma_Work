//
//  IconCell.swift
//  Checklists
//
//  Created by Yulia on 1/8/22.
//  Copyright © 2022 Distillery. All rights reserved.
//

import UIKit

final class IconCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!

    var iconData: String? { didSet { setupCell() } }

    private func setupCell() {
        guard let data = iconData else { return }

        icon.image = UIImage(named: data)
        title.text = data
    }
}
