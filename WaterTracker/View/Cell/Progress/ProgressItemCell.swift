//
//  ProgressItemCell.swift
//  WaterTracker
//
//  Created by nik on 24.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class ProgressItemCell: UICollectionViewCell {

    static let identifier = "ProgressItemCell"

    @IBOutlet weak var progressViewIndicator: GradientView!
    @IBOutlet weak var progressTitle: UILabel!

    func loadCell(_ item: Categories?) {
        var (top, down) = (#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        if let color = item?.getColorId() {
            (top, down) = WaterColor.getById(color).getColor()
        }
        progressViewIndicator.topColor = top
        progressViewIndicator.bottomColor = down
        progressTitle.text = item?.getTitle() ?? "Другое"

        backgroundColor = .clear
    }
}
