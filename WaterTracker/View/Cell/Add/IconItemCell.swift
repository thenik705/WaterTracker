//
//  IconItemCell.swift
//  WaterTracker
//
//  Created by Nik on 05.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class IconItemCell: UICollectionViewCell {

    static let identifier = "IconItemCell"

    @IBOutlet weak var iconBG: GradientView!
    @IBOutlet weak var iconCell: UIImageView!

    func loadCell(_ icon: WaterImage, _ color: WaterColor?, _ isSelect: Bool = false) {
        var (top, down) = (#colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1), #colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1))

        if let newColor = color {
            if isSelect {
                (top, down) = newColor.getColor()
            }
        }

        iconBG.topColor = top
        iconBG.bottomColor = down

        iconCell.tintColor = isSelect ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
        iconCell.image = icon.getImage()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
