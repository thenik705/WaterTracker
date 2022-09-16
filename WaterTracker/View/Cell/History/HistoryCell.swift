//
//  HistoryCell.swift
//  WaterTracker
//
//  Created by nik on 18.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class HistoryCell: UITableViewCell {

    static let identifier = "HistoryCell"

    @IBOutlet weak var eventBG: GradientView!
    @IBOutlet weak var eventImage: UIImageView!

    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventSubTitle: UILabel!
    @IBOutlet weak var eventCategoriesTitle: UILabel!
    @IBOutlet weak var eventProgress: UILabel!

    @IBOutlet weak var eventViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventItemCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorViewBottomConstraint: NSLayoutConstraint!

    var rowEvent: Event!

    func loadCell(_ event: Event) {
        rowEvent = event

        let water = rowEvent?.getWater()
        var (top, down) = (#colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1), #colorLiteral(red: 0.9325370789, green: 0.9449895024, blue: 0.9836121202, alpha: 1))
        let imageEvent = WaterImage.getById(water?.getImageId() ?? WaterImage.imageDefault.getId()).getImage()
        let percent = Int(rowEvent.percent)

        if let water = water {
            (top, down) = WaterColor.getById(water.getColorId()).getColor()
        }

        eventBG.topColor = top
        eventBG.bottomColor = down
        eventImage.image = imageEvent

        eventTitle.text = rowEvent.getTitle()
        eventSubTitle.text = rowEvent.getStrVolume()

//        eventCategoriesTitle.text = rowEvent?.getCategories()?.getTitle()
//        eventProgress.text = "\(percent) %"
//        eventProgress.textColor = percent > 0 ? .green : .red
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
