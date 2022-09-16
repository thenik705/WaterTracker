//
//  WelcomeTableViewController.swift
//  WaterTracker
//
//  Created by Nik on 27.04.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit

protocol WelcomeTableTableDelegate: class {
}

class WelcomeTableViewController: UITableView, UITableViewDataSource, UITableViewDelegate {

    var rootController: AddViewController!

    weak var welcomeTableDelegate: WelcomeTableTableDelegate?

    var title = ["All New", "Quick Creation", "Easy Organizing"]
    var detail = ["A completely rebuilt app that makes it easier than ever to create and organize reminders.",
                  "Just type. talk to Siri, or tap the new toolbar to create reminder. Siri also suggests reminders found in Messages.",
                  "Use automatic smart lists like Today and Flagged, or organize by grouping lists or reminders."]

    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
    }

    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: WelcomeCell.identifier, for: indexPath) as! WelcomeCell
        cell.loadCell(title[indexPath.row], detail[indexPath.row])

        cell.welcomeTitle.heroID = "sectionTitle\(indexPath.row)"
        cell.welcomeSubTitle.heroID = "sectionSubTitle\(indexPath.row)"
        cell.welcomeImage.heroID = "sectionCell\(indexPath.row)"
        return cell
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
}
