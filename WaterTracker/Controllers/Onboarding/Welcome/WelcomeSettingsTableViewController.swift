//
//  WelcomeSettingsTableViewController.swift
//  WaterTracker
//
//  Created by Nik on 28.04.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit
import CoreDataKit

class WelcomeSettingsTableViewController: AddTableViewController {

    var welcomeRootController: WelcomeSettingsViewController!

    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
    }

    // MARK: - TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowSection = sections[indexPath.section].getType()

        switch rowSection.getId() {
        case SectionEntity.Preview.getId():
            return loadPreviewCell(indexPath)
        case SectionEntity.Title.getId():
            return loadTitleCell(indexPath)
        case SectionEntity.Count.getId():
            return loadCountCell(indexPath)
        default:
            return loadAddEventCell(indexPath)
        }
    }

    // MARK: - Settings

    // MARK: - Additional functions
    func setController(_ controller: WelcomeSettingsViewController) {
        self.welcomeRootController = controller
    }

    override func loadPreviewCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: AddPreviewEventCell.identifier, for: indexPath) as! AddPreviewEventCell
        let (top, down) = (#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))

        cell.loadCell(nowSelectColor, image: nowSelectImage)
        cell.eventImage.image = nil
        cell.eventBG.topColor = top
        cell.eventBG.bottomColor = down

        return cell
    }

    override func loadTitleCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: AddTextCell.identifier, for: indexPath) as! AddTextCell

        cell.loadCell(nil, "Имя")
        cell.delegate = self
        cell.cellText.becomeFirstResponder()

        cell.cellBG.heroID = "sectionCell\(indexPath.section-1)"
        return cell
    }

    override func loadCountCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: WelcomeCountCell.welcomeIdentifier, for: indexPath) as! WelcomeCountCell

        cell.loadCell()
        cell.delegate = self

        cell.cellBG.heroID = "sectionCell\(indexPath.section-1)"
        return cell
    }

    override func updateImage(_ newImage: WaterImage) {
//        nowSelectImage = newImage
//
//        let indexPreview = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Preview)
//        let indexIcons = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Icons)
//
//        event?.getWater()?.imageId = nowSelectImage.getId()
//
//        if getCategories() {
//            if let cell = cellForRow(at: IndexPath(row: 0, section: indexPreview)) as? AddPreviewCategoriesCell {
//                cell.updateImage(nowSelectImage)
//            }
//        } else {
//            if let cell = cellForRow(at: IndexPath(row: 0, section: indexPreview)) as? AddPreviewEventCell {
//                cell.updateImage(nowSelectImage)
//            }
//        }
//
//        if let cell = cellForRow(at: IndexPath(row: 0, section: indexIcons)) as? AddIconCell {
//            cell.icons.updateImage(nowSelectImage)
//        }
    }

    override func updateCount(_ newCount: String) {
        let indexCount = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Count)

        if let cell = cellForRow(at: IndexPath(row: 0, section: indexCount)) as? AddCountCell {
        }
    }
}
