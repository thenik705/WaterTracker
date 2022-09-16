//
//  ViewController.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit
import DateUtilsKit
import SPAlert

class MainViewController: UIViewController {

    @IBOutlet weak var upViewPanel: UIView!
    @IBOutlet weak var mainTableView: MainTableViewController!

    var progressCollectionView: ProgressCollectionView! {
        didSet {
            if progressView != nil {
                progressCollectionView.rootController = self
                progressCollectionView.reloadData()
            }
        }
    }

    var progressView: MultiProgressView?

    var selectedDay = Day.values()[DateUtils.getDayOfWeek(Date())-1]
    var allVolumeDay: Double = 0.0
    let maxVolumeDay: Double = 2500.0

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        initSettings()

        NotificationCenter.default.addObserver(self, selector: #selector(updateInfo), name: NSNotification.Name(rawValue: "eventChanged"), object: nil)
        //        appDelegate().delegate = self
    }

    // MARK: - Settings
    func initSettings() {
        WaterHelpers.instance.loadEventDay(maxVolumeDay, selectedDay.date)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.isNavigationBarHidden = true

        mainTableView.mainTableDelegate = self
        mainTableView.setController(self)
        mainTableView.loadEvents()
//        initProgress()

        //colors
        loadColors()
    }

    // MARK: - Objc functions
    @objc func updateInfo() {
        mainTableView?.loadEvents()
    }

    // MARK: - Additional functions
    func loadColors() {
        //           filterView.backgroundColor = ThemeManager.currentTheme().navigationBackground
        //
        //           addTaskView.shadowColor = ThemeManager.currentTheme().shadowColor
        //           addTaskView.topColor = ColorEntity.getSelectAccentColor().getColor()
        //           addTaskView.bottomColor = ColorEntity.getSelectAccentColor().getColor()
        //           addImageView.tintColor = ColorEntity.getSelectAccentColor().returnBlackAndWhiteColor()
        //
        //           lineView.backgroundColor = ThemeManager.currentTheme().navigationBackground
        //           upViewPanel.backgroundColor = ThemeManager.currentTheme().navigationBackground
        //           downViewPanel.backgroundColor = ThemeManager.currentTheme().navigationBackground
        //           menuButton.tintColor = ThemeManager.currentTheme().titleText
        //           inboxButton.tintColor = ThemeManager.currentTheme().titleText
        //           projectButton.tintColor = ThemeManager.currentTheme().titleText
        //           contextButton.tintColor = ThemeManager.currentTheme().titleText
        //           tagButton.tintColor = ThemeManager.currentTheme().titleText
        //
//        view.backgroundColor = .systemBackground
    }

    func getCountCell() -> Int {
        var countWidthCell: Double = 72.3
        let width = Double(UIScreen.main.bounds.width-60.0)
        var countCell = 1
        let categories = getCategories().sorted(by: {$0.getEventsVolume() > $1.getEventsVolume()})
        let labelFont = UIFont.systemFont(ofSize: 12)

//        let wCustomItem = "Другое".size(with: labelFont).width
//        countWidthCell += Double(wCustomItem)+(wCustomItem >= 1 ? 30.0 : 0.0)
//        countCell += 1

        for category in categories {
            let wItem = category.getTitle().size(with: labelFont).width
            countWidthCell += Double(wItem)+(wItem >= 1 ? 30.0 : 0.0)

            if countWidthCell < width {
                countCell += 1
            } else {
                break
            }
        }

        return countCell == 0 ? 1 : countCell
    }

    func getEvents() -> [Event] {
        return WaterHelpers.instance.events
    }

    func getCategories() -> [Categories] {
           return CoreDataManager.loadFromDb(clazz: Categories.self, keyForSort: Const.SORT_POSITION)
       }

    func openEditController(_ sectionType: SectionType, _ water: Water? = nil, _ category: Categories? = nil) {
        let controller = Const.GET_STORYBOARD.instantiateViewController(withIdentifier: Const.ADD_VIEW_CONTROLLER) as! AddViewController

        controller.sectionType = sectionType
        controller.water = water
        controller.categories = category

        controller.rootController = self
        controller.addDelegate = self

        let nController = UINavigationController(rootViewController: controller)
        nController.modalPresentationStyle = .fullScreen
        self.present(nController, animated: true, completion: nil)
    }
}

//extension MainTableViewController: UIViewControllerTransitioningDelegate {
//    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let toViewController = segue.destination
//
//        if let selectedCell = sender as? UITableViewCell {
//            toViewController.transitioningDelegate = self
//            toViewController.modalPresentationStyle = .custom
//            toViewController.view.backgroundColor = selectedCell.backgroundColor
//
//            animationController.collapsedViewFrame = {
//                return selectedCell.frame
//            }
//            animationController.animationDuration = 1.0
//
//            if let indexPath = indexPath(for: selectedCell) {
//                deselectRow(at: indexPath, animated: false)
//            }
//        }
//    }
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return animationController
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return animationController
//    }
//}

extension MainViewController: SPStorkControllerDelegate {
    func didDismissStorkByTap() {
        print("SPStorkControllerDelegate - didDismissStorkByTap")
    }

    func didDismissStorkBySwipe() {
        print("SPStorkControllerDelegate - didDismissStorkBySwipe")
    }
}

extension MainViewController: AddViewControllerDelegate {
    func saveCategories(_ categories: Categories?, _ newCategories: Bool) {
        if let indexSectionCategories = mainTableView.sections.firstIndex(where: { $0.getId() == SectionEntity.Categories.getId() }) {
            if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: indexSectionCategories)) as? CategoriesCell {
                if let _ = categories {
                    DispatchQueue.main.asyncAfter(deadline: (.now() + 0.3)) {
                        SPAlert.present(title: newCategories ? "Добавлено" : "Обновлено", preset: .done)
                        SPVibration.impact(.success)
                        Utils().sounSystem(Const.SOUND_DONE)
                        cell.typeCollectionView.loadTypes()
                    }
                } else {
                    cell.typeCollectionView.loadTypes()
                }

                let indexCategories = SectionEntity.getAddValuesIndex(.main, SectionEntity.Categories)
                if let headerIconsSection = mainTableView.headerView(forSection: indexCategories) as? TableSectionHeader {
                    let countCategories = CoreDataManager.loadCount(clazz: Categories.self)
                    headerIconsSection.isShowAllButton(countCategories > Const.MAX_CATEGORIES_COUNT)
                }
            }
        }
    }

    func saveWater(_ water: Water?, _ newWater: Bool) {
        let countWaters = CoreDataManager.loadCount(clazz: Water.self)

        if let indexSectionWater = mainTableView.sections.firstIndex(where: { $0.getId() == SectionEntity.Waters.getId() }) {
            if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: indexSectionWater)) as? WatersCell {

                if let _ = water {
                    DispatchQueue.main.asyncAfter(deadline: (.now() + 0.3)) {
                        SPAlert.present(title: newWater ? "Добавлено" : "Обновлено", preset: .done)
                        SPVibration.impact(.success)
                        Utils().sounSystem(Const.SOUND_DONE)
                        cell.watersCollectionView.loadTypes()
                    }
                } else {
                    cell.watersCollectionView.loadTypes()
                }

                let indexWater = SectionEntity.getAddValuesIndex(.main, SectionEntity.Waters)
                if let headerWaterSection = mainTableView.headerView(forSection: indexWater) as? TableSectionHeader {
                    headerWaterSection.isShowAllButton(countWaters > Const.MAX_WATER_COUNT)
                }
            }

            if countWaters <= 4 {
                mainTableView.reloadSections(IndexSet(arrayLiteral: indexSectionWater), with: .automatic)
            }
        }
    }

    func saveEvent(_ event: Event?) {

        selectedDay.updateProgress()
        mainTableView.updateEvent(event)

//        if let saveEvent = event {
//            mainTableView.events.insert(saveEvent, at: 0)
//        }

//        if let indexSectionProgress = mainTableView.sections.firstIndex(where: { $0.id == SectionEntity.Progress.id }) {
//          mainTableView.reloadRows(at: [IndexPath(row: 0, section: indexSectionProgress)], with: .automatic)
//            mainTableView.reloadSections(IndexSet(arrayLiteral: indexSectionProgress), with: .automatic)
//        }
//
//        if let indexSectionHistory = mainTableView.sections.firstIndex(where: { $0.id == SectionEntity.History.id }) {
//            mainTableView.reloadSections(IndexSet(arrayLiteral: indexSectionHistory), with: .automatic)
//            if let cell = mainTableView.cellForRow(at: IndexPath(row: 0, section: indexSectionHistory)) as? HistoryCell {
//
//            }
//            mainTableView.reloadRows(at: [IndexPath(row: 0, section: indexSectionHistory)], with: .automatic)
//        }
    }
}

extension MainViewController: WaterCollectionViewControllerDelegate {
    func selectWaters(_ waters: [Water]) {

    }

    func selectWater(_ water: Water?, edit: Bool) {
//        tapOpenSettings()
        openEditController(edit ? .editWater : (water == nil ? .addWater : .addEvent), water, nil)
    }
}

extension MainViewController: CategoriesCollectionViewControllerDelegate {
    func selectCategories(_ category: Categories?) {
        openEditController(.category, nil, category)
    }
}

extension MainViewController: MainTableDelegate {
    func tapOpenSettings() {
        let controller = Const.GET_STORYBOARD.instantiateViewController(withIdentifier: Const.SETTINGS_VIEW_CONTROLLER) as! SettingsViewController
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }

    func tapAddEntity() {
        let waterTypeCount = CoreDataManager.loadCount(clazz: Water.self)

        if waterTypeCount == 0 {
            openEditController(.addWater)
        } else {
            openEditController(.addEvent)
        }
    }
}

extension MainViewController: CalendarDelegate {
    func selectDay(_ calendar: CalendarCollectionViewController, _ day: Day) {
        if selectedDay.getId() == day.getId() {
            return
        }

        let isFirstWeekday = Calendar.current.firstWeekday == 1
        let wasDay = isFirstWeekday ? (selectedDay.getId() == 7 ? 0 : selectedDay.getId()) : selectedDay.getId() - 1

        selectedDay = day
        WaterHelpers.instance.loadEventDay(maxVolumeDay, selectedDay.date)

        let newDay = selectedDay.getId() - (isFirstWeekday ? 0 : 1)

        UIView.animate(withDuration: 0.2, animations: {
            calendar.reloadItems(at: [IndexPath(row: wasDay, section: 0)])
        }, completion: { (_) in
            UIView.animate(withDuration: 0.1) {
                calendar.reloadItems(at: [IndexPath(row: (isFirstWeekday && newDay == 7 ? 0 : newDay), section: 0)])
            }
        })
    }
}
