//
//  CalendarCell.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class CalendarCell: UITableViewCell {

    static let identifier = "CalendarCell"

    @IBOutlet weak var calendar: CalendarCollectionViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
