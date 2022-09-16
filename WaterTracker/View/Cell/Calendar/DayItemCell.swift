//
//  DayItemCell.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class DayItemCell: UICollectionViewCell {

    static let identifier = "DayItemCell"

    @IBOutlet weak var progressView: WaterWaveView!

    func loadCell(_ day: Day, _ isActive: Bool = false) {
        progressView.loadViewInfo("\(day.dayNumber)", day.getTitle(), isActive, day.progress)

        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
