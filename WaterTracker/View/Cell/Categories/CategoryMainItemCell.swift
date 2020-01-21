//
//  TypeItemCell.swift
//  WaterTracker
//
//  Created by nik on 27.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class CategoryMainItemCell: UICollectionViewCell {

    static let identifier = "CategoryMainItemCell"

    @IBOutlet weak var categoryBG: GradientView!

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryEventName: UILabel!
    @IBOutlet weak var categorieyAllVolume: UILabel!
    @IBOutlet weak var addEventView: UIView!

    @IBOutlet weak var categoryEventNameConstraint: NSLayoutConstraint!

    var isSelectCategory = true
    var rowCategory: Categories?

    func loadCell(_ category: Categories?, shouldColorCell: Bool) {
        rowCategory = category
        isSelectCategory = shouldColorCell

        var (top, down) = (#colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9843137255, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9843137255, alpha: 1))
        let isCategory = rowCategory != nil
        let imageCategory = WaterImage.getById(category?.getImageId() ?? WaterImage.imageDefault.getId()).getImage()

        let (categoryColor, addColor) = (isSelectCategory ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
        if let categories = category {
            if isSelectCategory {
                (top, down) = WaterColor.getById(categories.getColorId()).getColor()
            }
        }

        categoryBG.topColor = top
        categoryBG.bottomColor = down

        categoryImage.image = isCategory ? imageCategory : UIImage(systemName: "plus.circle.fill")
        categoryImage.tintColor = isCategory ? categoryColor : addColor
        categoryName.text = isCategory ? category?.getTitle() : "Добавить категорию"
        categoryName.textColor = categoryImage.tintColor

        categorieyAllVolume?.text = isCategory ? "\([50,200,450].randomElement()!) мл" : nil
        categoryEventNameConstraint?.constant = isCategory ? 17 : 0
        addEventView?.alpha = isCategory ? 1 : 0
    }
}

class CategoryItemCell: CategoryMainItemCell {
    static let identifierId = "CategoryItemCell"

    func isSelectCategories() {
        isSelectCategory = !isSelectCategory
        loadCell(rowCategory, shouldColorCell: isSelectCategory)
    }
}
