//
//  WelcomeCell.swift
//  WaterTracker
//
//  Created by Nik on 27.04.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit

class WelcomeCell: UITableViewCell {

    static let identifier = "WelcomeCell"

    @IBOutlet weak var welcomeImage: UIView!
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var welcomeSubTitle: UILabel!

    func loadCell(_ title: String, _ subTitle: String) {
        welcomeTitle.text = title
        welcomeSubTitle.text = subTitle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
