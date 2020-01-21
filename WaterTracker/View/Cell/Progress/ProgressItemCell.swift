//
//  ProgressItemCell.swift
//  WaterTracker
//
//  Created by nik on 24.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class ProgressItemCell: UICollectionViewCell {

    static let identifier = "ProgressItemCell"

    @IBOutlet weak var progressViewIndicator: GradientView!
    @IBOutlet weak var progressTitle: UILabel!

    func loadCell(_ item: ProgressViewSection) {

        progressViewIndicator = item.sectionGradientView
        progressTitle.text = item.titleLabel.text

        backgroundColor = .clear
    }
}
