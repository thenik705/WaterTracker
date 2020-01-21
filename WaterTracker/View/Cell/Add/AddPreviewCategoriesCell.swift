//
//  AddPreviewCategoriesCell.swift
//  WaterTracker
//
//  Created by nik on 02.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class AddPreviewCategoriesCell: UITableViewCell {

    static let identifier = "AddPreviewCategoriesCell"

    @IBOutlet weak var categoryBG: GradientView!

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!

    func loadCell(_ color: WaterColor?, image: WaterImage?, title: String = "") {
        var (top, down) = (#colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1), #colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1))
        var imageEvent = WaterImage.imageDefault.getImage()

        if let newColor = color {
           (top, down) = newColor.getColor()
        }

        if let newImage = image {
            imageEvent = newImage.getImage()
        }

        categoryBG.topColor = top
        categoryBG.bottomColor = down

        categoryImage.image = imageEvent
        updateTitle(title)

        backgroundColor = .clear
    }

    func updateTitle(_ newTitle: String) {
        var title = newTitle

        if title.isEmpty {
            title = "Название"
        }

        categoryName.text = title
        categoryName.textColor = newTitle.isNotEmpty() ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4986245599)
    }

    func updateImage(_ newImage: WaterImage) {
        categoryImage.image = newImage.getImage()
    }
}
