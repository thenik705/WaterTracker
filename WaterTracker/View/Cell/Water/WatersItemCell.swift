//
//  WatersItemCell.swift
//  WaterTracker
//
//  Created by Nik on 26.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class WatersItemCell: UICollectionViewCell {

    static let identifier = "WatersItemCell"

    @IBOutlet weak var watersBG: GradientView!

    @IBOutlet weak var waterImage: UIImageView!
    @IBOutlet weak var waterName: UILabel?

    var isSelectWaterItem = true
    var rowWater: Water?

    func loadCell(_ water: Water?, shouldColorCell: Bool = true) {
        rowWater = water
        isSelectWaterItem = shouldColorCell
        let isWater = rowWater != nil

        var (top, down) = (#colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9843137255, alpha: 1), #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9843137255, alpha: 1))

        let (waterColor, addColor) = (isSelectWaterItem ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
        if let water = water {
            if isSelectWaterItem {
                (top, down) = WaterColor.getById(water.getColorId()).getColor()
            }
        }

        watersBG.topColor = top
        watersBG.bottomColor = down

        waterImage.image = isWater ? WaterImage.getById(water!.getImageId()).getImage() : UIImage(systemName: "plus.circle.fill")
        waterImage.tintColor = isWater ? waterColor : addColor
        waterName?.text = isWater ? rowWater?.getTitle() : "Добавить"
        waterName?.textColor = waterImage.tintColor
    }

    func isSelectWater() {
        isSelectWaterItem = !isSelectWaterItem
        loadCell(rowWater, shouldColorCell: isSelectWaterItem)
    }
}

class WatersAddItemCell: WatersItemCell {
    static let addIdentifier = "WatersAddItemCell"
}
