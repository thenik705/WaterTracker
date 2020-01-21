//
//  AddCategoriesCell.swift
//  WaterTracker
//
//  Created by Nik on 07.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class AddCategoriesCell: UITableViewCell {

    static let identifier = "AddCategoriesCell"

    @IBOutlet weak var addViewBG: GradientView!
    @IBOutlet weak var addImage: UIImageView!

    func loadCell() {
        addViewBG.topColor = #colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1)
        addViewBG.bottomColor = #colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1)

        backgroundColor = .clear
    }
}
