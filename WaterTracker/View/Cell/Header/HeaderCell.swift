//
//  HeaderCell.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import DateUtilsKit

protocol HeaderCellDelegate: class {
}

class HeaderCell: UITableViewCell {

    static let identifier = "HeaderCell"

     weak var delegate: HeaderCellDelegate?

    @IBOutlet weak var titleDate: UILabel!
    @IBOutlet weak var titleSelectDate: UILabel!

    @IBOutlet weak var userImage: UIImageView!

    func loadCell() {
        titleDate.text = DateUtils.getTimeToday(Date())?.uppercased()
        titleSelectDate.text = "Сегодня"

//        backgroundColor = .clear
    }
}
