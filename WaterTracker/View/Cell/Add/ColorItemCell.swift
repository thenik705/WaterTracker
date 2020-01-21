//
//  ColorItemCell.swift
//  WaterTracker
//
//  Created by nik on 02.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class ColorItemCell: UICollectionViewCell {

    static let identifier = "ColorItemCell"

    @IBOutlet weak var colorView: GradientView!
    @IBOutlet weak var colorIndicatorView: UIView!

    func loadCell(_ color: WaterColor, _ isSelect: Bool = false) {
        let (top, down) = color.getColor()

        colorView.topColor = top
        colorView.bottomColor = down

        colorIndicatorView.isHidden = !isSelect
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
