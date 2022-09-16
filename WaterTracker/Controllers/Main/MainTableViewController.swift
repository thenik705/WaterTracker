//
//  MainTableView.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol MainTableDelegate: class {
//    func selectTask(_ task: Task)
    func tapAddEntity()
    func tapOpenSettings()
}

class MainTableViewController: UITableView, UITableViewDataSource, UITableViewDelegate {

    var sections = Sections.createSections()
    var rootController: MainViewController!
    var calendarCollectionView: CalendarCollectionViewController!
    var events = [Event]()
    var reloadInfo = false

    weak var mainTableDelegate: MainTableDelegate?

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
//        cell.delegate = rootController
        cell.background.backgroundColor = .clear

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowSection = sections[section].getType()

        switch rowSection.getId() {
        case SectionEntity.History.getId():
            return events.isEmpty ? 1 : events.count
        case SectionEntity.Actions.getId():
            return 2
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowSection = sections[indexPath.section].getType()

        switch rowSection.getId() {
        case SectionEntity.Header.getId():
            return loadHeaderCell(indexPath)
        case SectionEntity.Calendar.getId():
            return loadCalendarCell(indexPath)
        case SectionEntity.AddEntity.getId():
            return loadAddEntityCell(indexPath)
        case SectionEntity.Progress.getId():
            return loadProgressCell(indexPath)
        case SectionEntity.Waters.getId():
            return loadWatersCell(indexPath)
        case SectionEntity.Categories.getId():
            return loadCategoriesCell(indexPath)
        case SectionEntity.History.getId():
            return loadHistoryCell(indexPath)
        case SectionEntity.Actions.getId():
            return loadActionCell(indexPath)
        default:
            return loadSubstrateCell(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowSection = sections[indexPath.section].getType()

        if rowSection.getId() == SectionEntity.Actions.getId() {
            switch indexPath.row {
            case 0:
                print("tapped index 0")
            default:
                mainTableDelegate?.tapOpenSettings()
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let rowSection = sections[section].getType()
        return rowSection.getIsHidden() ? 1 : rowSection.getSubTitle().isNotEmpty() ? 60 : 35//sections[section].items.count != 0 ? 35 : 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let rowSection = sections[section].getType()
        return rowSection.getIsHidden() ? 1 : 15
    }

    // MARK: - Settings
    func initSettings() {
        dataSource = self
        delegate = self

        estimatedRowHeight = 200
        sectionFooterHeight = 0
        tableFooterView = UIView(frame: .zero)

        let nib = UINib(nibName: TableSectionHeader.identifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: TableSectionHeader.identifier)
    }

    // MARK: - Additional functions
    func setController(_ controller: MainViewController) {
        self.rootController = controller
    }

    func loadEvents() {
        events = rootController?.getEvents() ?? [Event]()
        reloadInfo = true
        updateMainSection()
    }

    func updateMainSection() {
        let isHideProgressAndHistory = events.isEmpty

//        let indexProgressSection = sections.firstIndex(where: { $0.getId() == SectionEntity.Progress.getId() }) ?? 0
//        let indexHistorySection = sections.firstIndex(where: { $0.getId() == SectionEntity.History.getId() }) ?? 0
//
//        if let indexCalender = sections.firstIndex(where: { $0.id == SectionEntity.Calendar.id }) {
//            let substrateSection = SectionEntity.Substrate
//            let progressSection = SectionEntity.Progress
//            let historySection = SectionEntity.History
//
//            let indexProgress = indexCalender+1
//            var indexHistory = sections.count
//
//            if isHideProgressAndHistory {
//                let section = substrateSection
//
//                let newSubstrateProgress = Sections(section.getId(), section.getTitle(), section.getSubTitle(), emptyTitle: "", emptySubTitle: "Нет данных о напитках")
//                let newSubstrateHistory = Sections(section.getId(), section.getTitle(), section.getSubTitle(), emptyTitle: "Пусто", emptySubTitle: "Нет последних напитков")
//
//                if let indexProgress = indexProgressSection {
//                    sections.remove(at: indexProgress)
//                    sections.insert(newSubstrateProgress, at: indexProgress)
//                } else {
//                    sections.insert(newSubstrateProgress, at: indexProgress)
//                }
//
//                indexHistory = sections.count
//
//                if let indexHistory = indexHistorySection {
//                    sections.remove(at: indexHistory)
//                    sections.insert(newSubstrateHistory, at: indexHistory)
//                } else {
//                    sections.insert(newSubstrateHistory, at: indexHistory)
//                }
//            } else {
//                sections.remove(at: indexProgress)
//                sections.remove(at: indexHistory)
//
//                sections.insert(Sections(progressSection.getId(), progressSection.getTitle(), progressSection.getSubTitle()), at: indexProgress)
//                sections.insert(Sections(historySection.getId(), historySection.getTitle(), historySection.getSubTitle()), at: indexHistory)
//            }

                reloadData()
//        } else {
//            reloadData()
//        }
        
//        reloadInfo = false
    }

    func loadHeaderCell(_ indexPath: IndexPath) -> UITableViewCell {
         let cell = dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
        cell.loadCell()
        return cell
    }

    func loadCalendarCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: CalendarCell.identifier, for: indexPath) as! CalendarCell
        let calendar = (cell.calendar as CalendarCollectionViewController)

        calendar.setController(rootController)
        calendar.calendarDelegate = rootController
        cell.contentView.layoutIfNeeded()
        return cell
    }

    func loadAddEntityCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: AddEntityCell.identifier, for: indexPath) as! AddEntityCell
        cell.loadCell()
        cell.addEntityDelegate = self
        return cell
    }

    func loadProgressCell(_ indexPath: IndexPath) -> UITableViewCell {
        if events.isEmpty {
            return loadSubstrateCell(indexPath)
        }

        let cell = dequeueReusableCell(withIdentifier: ProgressCell.identifier, for: indexPath) as! ProgressCell
        cell.loadCell(reloadInfo, rootController.getCountCell())
        reloadInfo = false
        rootController.progressView = cell.progressView
        rootController.progressCollectionView = cell.progressCollectionView

        return cell
    }

    func loadCategoriesCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: CategoriesCell.identifier, for: indexPath) as! CategoriesCell
        cell.loadCell()
        cell.typeCollectionView.categoriesDelegate = rootController
        return cell
    }

    func loadWatersCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: WatersCell.identifier, for: indexPath) as! WatersCell
        cell.loadCell()
        cell.watersCollectionView.waterDelegate = rootController
        return cell
    }

    func loadHistoryCell(_ indexPath: IndexPath) -> UITableViewCell {
        if events.isEmpty {
            return loadSubstrateCell(indexPath)
        }

        let cell = dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        let rowEvent = events[indexPath.row]

        cell.loadCell(rowEvent)

//        cell.eventViewTopConstraint.constant = 0
//        cell.eventViewHeightConstraint.constant = 50
//        cell.eventItemCenterConstraint.constant = 0
//        cell.eventViewBottomConstraint.constant = 0
//        cell.eventView.layer.cornerRadius = 0
        cell.separatorView.alpha = 1
        cell.separatorViewBottomConstraint.constant = -0.5

        if indexPath.row == 0 {
//            cell.eventView.layer.cornerRadius = 10

//            if events.count > 1 {
//                cell.eventViewHeightConstraint.constant = 60
//                cell.eventViewBottomConstraint.constant = -10
//                cell.eventItemCenterConstraint.constant = -5
//                cell.separatorViewBottomConstraint.constant = 9.5
//            }

            cell.separatorView.alpha = events.count > 1 ? 1 : 0
        } else if indexPath.row == events.count-1 {
//            cell.eventView.layer.cornerRadius = 10
//            cell.eventViewHeightConstraint.constant = 60
//            cell.eventViewTopConstraint.constant = -10
//            cell.eventItemCenterConstraint.constant = 5
            cell.separatorView.alpha = 0
        }

        return cell
    }

    func loadActionCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: ActionCell.identifier, for: indexPath) as! ActionCell

        cell.textLabel?.text = indexPath.row == 0 ? "Премиум-доступ" : "Настройки"
        cell.backgroundColor = nil
        return cell
    }

    func loadSubstrateCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: SubstrateCell.identifier, for: indexPath) as! SubstrateCell
        let rowSection = sections[indexPath.section]

        cell.loadCell(rowSection.emptyTitle, rowSection.emptySubTitle)

        return cell
    }

    func updateEvent(_ event: Event?) {
        let indexEvent = events.firstIndex(where: { $0.getId() == event?.getId() })

        if let saveEvent = event {
            if indexEvent == nil {
                events.insert(saveEvent, at: 0)
                WaterHelpers.instance.addEvent(saveEvent)
            }
        }
    }
}

extension MainTableViewController: AddEntityDelegate {
    func tapAddEntity(_ cell: AddEntityCell) {
        mainTableDelegate?.tapAddEntity()
    }
}
