//
//  AddTableViewController.swift
//  WaterTracker
//
//  Created by nik on 02.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol AddTableDelegate: class {
//    func selectTask(_ task: Task)
}

class AddTableViewController: UITableView, UITableViewDataSource, UITableViewDelegate {

    var sections = [Sections]()
    var rootController: AddViewController!
    var nowSelectColor = WaterColor.SkyBlue
    var nowSelectImage = WaterImage.imageDefault
    var nowSelectCategory: Categories?
    var nowSectionType: SectionType = .addWater

    var textTitle = String()
    var event: Event?
    var water: Water?
    var categories: Categories?

    weak var addTableDelegate: AddTableDelegate?

    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = dequeueReusableHeaderFooterView(withIdentifier: TableSectionHeader.identifier) as! TableSectionHeader
        let rowSection = sections[section]

        if rowSection.getType().getIsHidden() {
            return UIView()
        }

        cell.loadSection(rowSection)
        cell.isShowAllButton(rowSection.getType().getIsShowAll())
        cell.background.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowSection = sections[indexPath.section].getType()

        switch rowSection.getId() {
        case SectionEntity.Preview.getId():
            return loadPreviewCell(indexPath)
        case SectionEntity.Title.getId():
            return loadTitleCell(indexPath)
        case SectionEntity.Count.getId():
            return loadCountCell(indexPath)
        case SectionEntity.Color.getId():
            return loadColorCell(indexPath)
        case SectionEntity.Icons.getId():
            return loadIconCell(indexPath)
        case SectionEntity.Categories.getId():
            return loadCategoriesCell(indexPath)
        case SectionEntity.Waters.getId():
            return loadWatersCell(indexPath)
        default:
            return loadAddEventCell(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let rowTask = sections[indexPath.section].get(index: indexPath.row)
//        mainTaskDelegate?.selectTask(rowTask)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let rowSection = sections[section].getType()
        return rowSection.getIsHidden() ? 1 : rowSection.getSubTitle().isNotEmpty() ? 60 : 35
    }

    // MARK: - Settings
    func initSettings() {
        dataSource = self
        delegate = self

        estimatedRowHeight = 200
        sectionFooterHeight = 0
        separatorStyle = .none
        backgroundColor = nil

        let nib = UINib(nibName: TableSectionHeader.identifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: TableSectionHeader.identifier)
    }

    // MARK: - Additional functions
    func setController(_ controller: AddViewController) {
        self.rootController = controller
    }

    func loadInfo(_ sectionType: SectionType = .addWater) {
        nowSectionType = sectionType
        sections = Sections.createSections(nowSectionType)

        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.transitionCrossDissolve, UIView.AnimationOptions.beginFromCurrentState],
            animations: {
                self.reloadData()
        })
    }

    func loadPreviewCell(_ indexPath: IndexPath) -> UITableViewCell {
        switch nowSectionType {
        case .addWater:
            let cell = dequeueReusableCell(withIdentifier: AddPreviewEventCell.identifier, for: indexPath) as! AddPreviewEventCell
            cell.loadCell(nowSelectColor, image: nowSelectImage)
            return cell
        case .category:
            let cell = dequeueReusableCell(withIdentifier: AddPreviewCategoriesCell.identifier, for: indexPath) as! AddPreviewCategoriesCell
            cell.loadCell(nowSelectColor, image: nowSelectImage, title: categories?.getTitle() ?? textTitle)
            return cell
        default:
            let cell = dequeueReusableCell(withIdentifier: AddPreviewEventCell.identifier, for: indexPath) as! AddPreviewEventCell
            cell.loadCell(nowSelectColor, image: nowSelectImage)
            return cell
        }
    }

    func loadTitleCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: AddTextCell.identifier, for: indexPath) as! AddTextCell

        cell.loadCell(returnEntity())
        cell.delegate = self

        cell.isUserInteractionEnabled = nowSectionType != .addEvent
        return cell
    }

    func loadCountCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: AddCountCell.identifier, for: indexPath) as! AddCountCell

        cell.loadCell(event)
        cell.delegate = self

        if nowSectionType == .addEvent {
            cell.cellText.becomeFirstResponder()
        }

        return cell
    }

    func loadColorCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: AddColorCell.identifier, for: indexPath) as! AddColorCell
        let colors = (cell.colors as AddColorsCollectionView)
        colors.nowSelectColor = nowSelectColor

        rootController.colorCollectionView = colors
        cell.contentView.layoutIfNeeded()

        return cell
    }

    func loadIconCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: AddIconCell.identifier, for: indexPath) as! AddIconCell
        let icons = (cell.icons as AddIconsCollectionView)
        icons.nowSelectImage = nowSelectImage

        rootController.imageCollectionView = icons
        cell.contentView.layoutIfNeeded()

        return cell
    }

    func loadCategoriesCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: CategoriesCell.identifier, for: indexPath) as! CategoriesCell

        cell.loadCell(nowSelectCategory, false)
        rootController.categoriesCollectionView = (cell.typeCollectionView as CategoriesCollectionView)
        cell.contentView.layoutIfNeeded()

        return cell
    }

    func loadWatersCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: WatersCell.identifier, for: indexPath) as! WatersCell

        cell.loadCell(categories?.getWaters(), false)
        cell.watersCollectionView.waterDelegate = rootController
        return cell
    }

    func loadAddEventCell(_ indexPath: IndexPath) -> UITableViewCell {
//         let cell = dequeueReusableCell(withIdentifier: CategoriesCell.identifier, for: indexPath) as! CategoriesCell
        return UITableViewCell()
    }

    func updateTitle(_ newTitle: String) {
        let indexPreview = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Preview)
        let indexCount = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Count)
        let indexIcons = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Icons)

        event?.getWater()?.title = newTitle
        water?.title = newTitle
        categories?.title = newTitle

        if getCategories() {
            if let cell = cellForRow(at: IndexPath(row: 0, section: indexPreview)) as? AddPreviewCategoriesCell {
                cell.updateTitle(newTitle)
            }
        }

        if let headerCountSection = headerView(forSection: indexCount) as? TableSectionHeader {
            headerCountSection.setSubTextSection(newTitle, getCategories())
        }

        if let headerIconsSection = headerView(forSection: indexIcons) as? TableSectionHeader {
             headerIconsSection.setSubTextSection(newTitle, getCategories())
         }
    }

    func updateColor(_ newColor: WaterColor) {
        nowSelectColor = newColor

        let indexPreview = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Preview)
        let indexIcons = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Icons)
        let indexColor = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Color)

        event?.getWater()?.colorId = nowSelectColor.getId()

        if getCategories() {
            if let cell = cellForRow(at: IndexPath(row: 0, section: indexPreview)) as? AddPreviewCategoriesCell {
                let (top, down) = nowSelectColor.getColor()

                cell.categoryBG.topColor = top
                cell.categoryBG.bottomColor = down
            }
        } else {
            if let cell = cellForRow(at: IndexPath(row: 0, section: indexPreview)) as? AddPreviewEventCell {
                let (top, down) = nowSelectColor.getColor()

                cell.eventBG.topColor = top
                cell.eventBG.bottomColor = down
            }
        }

        if let cell = cellForRow(at: IndexPath(row: 0, section: indexColor)) as? AddColorCell {
            cell.colors.updateColor(rootController.lastSelectColor, nowSelectColor)
        }

        if let cell = cellForRow(at: IndexPath(row: 0, section: indexIcons)) as? AddIconCell {
            cell.icons.reloadData()
        }
    }

    func updateImage(_ newImage: WaterImage) {
        nowSelectImage = newImage

        let indexPreview = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Preview)
        let indexIcons = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Icons)

        event?.getWater()?.imageId = nowSelectImage.getId()

        if getCategories() {
            if let cell = cellForRow(at: IndexPath(row: 0, section: indexPreview)) as? AddPreviewCategoriesCell {
                cell.updateImage(nowSelectImage)
            }
        } else {
            if let cell = cellForRow(at: IndexPath(row: 0, section: indexPreview)) as? AddPreviewEventCell {
                cell.updateImage(nowSelectImage)
            }
        }

        if let cell = cellForRow(at: IndexPath(row: 0, section: indexIcons)) as? AddIconCell {
            cell.icons.updateImage(nowSelectImage)
        }
    }

    func updateCount(_ newCount: String) {
        let indexCount = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Count)

        event?.volume = newCount

        if let cell = cellForRow(at: IndexPath(row: 0, section: indexCount)) as? AddCountCell {
            cell.loadCell(event)
        }
    }

    func updateCategories(_ nowCategory: Categories?) {
        let indexCategory = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Categories)

        water?.categoriesId = nowCategory?.id ?? -1

        if let cell = cellForRow(at: IndexPath(row: 0, section: indexCategory)) as? CategoriesCell {
            cell.typeCollectionView.updateCategories(nowCategory)
        }
    }

    func updateWaters(_ nowWaters: [Water]) {
        let indexWaters = SectionEntity.getAddValuesIndex(nowSectionType, SectionEntity.Waters)

        if let cell = cellForRow(at: IndexPath(row: 0, section: indexWaters)) as? WatersCell {
            cell.watersCollectionView.updateWaters(nowWaters)
        }
    }

    func getCategories() -> Bool {
        return nowSectionType == .category
    }

    func returnEntity() -> ITitle? {
        switch nowSectionType {
        case .addWater:
            return water
        case .category:
            return categories
        default:
            return water == nil ? event : water
        }
    }

    func loadCategory(_ categories: Categories?) {
        self.categories = categories

        rootController?.nowSelectImage = (WaterImage.getById(categories?.getImageId() ?? WaterImage.imageDefault.getId()))
        rootController?.nowSelectColor = (WaterColor.getById(categories?.getColorId() ?? WaterColor.SkyBlue.getId()))
        updateTitle(categories?.getTitle() ?? "")
    }

    func loadWater(_ water: Water?, _ event: Event? = nil) {
        self.water = water
        self.event = event

        rootController?.nowSelectImage = (WaterImage.getById(water?.getImageId() ?? WaterImage.imageDefault.getId()))
        rootController?.nowSelectColor = (WaterColor.getById(water?.getColorId() ?? WaterColor.SkyBlue.getId()))
        rootController?.selectCategories(water?.getCategories())
        updateTitle(water?.getTitle() ?? "")
    }
}

extension AddTableViewController: AddTextCellDelegate {
    func cellDidChangeSelection(_ editingCell: UITableViewCell, _ textField: UITextField) {
        if let text = textField.text {
            if editingCell is AddCountCell {
                updateCount(text)
            } else if editingCell is AddTextCell {
                updateTitle(text)
            }
        }
    }

    func cellFieldShouldBeginEditing(_ editingCell: UITableViewCell) -> Bool {
        return true
    }

    func cellFieldShouldEndEditing(_ editingCell: UITableViewCell) -> Bool {
        return true
    }

    func cellTextField(_ textField: UITextField, range: NSRange, string: String, editingCell: UITableViewCell) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }

        return true
    }

    func cellTapDeleteButton(_ editingCell: UITableViewCell) -> Bool {
        if editingCell is AddCountCell {
            updateCount("")
        } else if editingCell is AddTextCell {
            updateTitle("")
        }

        return true
    }

    func cellDidBeginEditing(_ editingCell: UITableViewCell) {
    }

    func cellDidEndEditing(_ editingCell: UITableViewCell) {
    }
}
