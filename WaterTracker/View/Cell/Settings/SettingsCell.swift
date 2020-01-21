//
//  SettingsCell.swift
//  WaterTracker
//
//  Created by nik on 05.01.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    static let identifier = "SettingsCell"

    @IBOutlet weak var settingsBG: UIView!

    @IBOutlet weak var settingsTitle: UILabel!
    @IBOutlet weak var settingsSubTitle: UILabel!
    @IBOutlet weak var settingsImage: UIImageView!

    func loadCell(_ section: SectionEntity, _ row: Int) {

        if let sections = SettingsSections.byId(section.getId()) {
            let cellInfo = sections.childrens[row]

            settingsTitle.text = cellInfo.title
            settingsSubTitle.text = cellInfo === SettingsSectionsEntity.Premium ? "Активен" : nil
            settingsImage.image = cellInfo.image
            settingsBG.backgroundColor = cellInfo.color
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
