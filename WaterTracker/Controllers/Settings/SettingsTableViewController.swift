//
//  SettingsTableViewController.swift
//  WaterTracker
//
//  Created by nik on 05.01.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit

protocol SettingTableDelegate: class {
}

class SettingsTableViewController: UITableView, UITableViewDataSource, UITableViewDelegate {

    var sections = Sections.createSections(.settings)
    var rootController: AddViewController!

    weak var settingsTableDelegate: SettingTableDelegate?

    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowSection = sections[section].getType()
        return SectionEntity.getTitleCell(rowSection.getId())
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let rowSection = sections[section].getType()
        return rowSection.getIsHidden() ? nil : rowSection.getTitle()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as! SettingsCell
        let rowSection = sections[indexPath.section].getType()

        cell.loadCell(rowSection, indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let rowSection = sections[section].getType()
        return rowSection === SectionEntity.Support ? rowSection.getSubTitle() : nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Settings
    func initSettings() {
        dataSource = self
        delegate = self

        estimatedRowHeight = 200
        sectionFooterHeight = 0
    }

    // MARK: - Additional functions
    func setController(_ controller: AddViewController) {
        self.rootController = controller
    }
}
