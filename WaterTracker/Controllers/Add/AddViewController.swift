//
//  AddViewController.swift
//  WaterTracker
//
//  Created by nik on 02.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol AddViewControllerDelegate: class {
    func saveCategories(_ categories: Categories?, _ newCategories: Bool)
    func saveWater(_ water: Water?, _ newWater: Bool)
    func saveEvent(_ event: Event?)

//    func deleteCategories(_ deleteEvent: Bool)
}

class AddViewController: UIViewController {

    @IBOutlet weak var addTableView: AddTableViewController!
    @IBOutlet weak var addEditButton: UIButton!

    var rootController: MainViewController?
    weak var addDelegate: AddViewControllerDelegate?

    var lightStatusBar = false
    var isNewEntity = false

    var event: Event?
    var water: Water?
    var categories: Categories?
    var sectionType: SectionType = .addWater

    var lastSelectColor = WaterColor.SkyBlue
    var nowSelectColor = WaterColor.SkyBlue {
        didSet {
            addTableView.updateColor(nowSelectColor)
        }
    }

    var nowSelectImage = WaterImage.imageDefault {
        didSet {
            addTableView.updateImage(nowSelectImage)
        }
    }

    var nowSelectCategory: Categories? {
        didSet {
            addTableView.updateCategories(nowSelectCategory)
        }
    }

    var nowSelectWaters = [Water]() {
        didSet {
            addTableView.updateWaters(nowSelectWaters)
        }
    }

    var colorCollectionView: AddColorsCollectionView! {
        didSet {
            if colorCollectionView != nil {
                colorCollectionView.setController(self)
                colorCollectionView.colorsDelegate = self
                colorCollectionView.updateColor(lastSelectColor, nowSelectColor)
            }
        }
    }

    var imageCollectionView: AddIconsCollectionView! {
        didSet {
            if imageCollectionView != nil {
                imageCollectionView.setController(self)
                imageCollectionView.iconsDelegate = self
                imageCollectionView.updateImage(nowSelectImage)
            }
        }
    }

    var categoriesCollectionView: CategoriesCollectionView! {
        didSet {
            if categoriesCollectionView != nil {
                categoriesCollectionView.categoriesDelegate = self
                categoriesCollectionView.updateCategories(nowSelectCategory)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSettings()

        disnissKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lightStatusBar = true
        self.navigationController?.isNavigationBarHidden = false
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: - Settings
    func initSettings() {
        var navButtons = [UIBarButtonItem]()

        let buttonClose = Button.closeButton()
        buttonClose.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        navButtons.append(UIBarButtonItem(customView: buttonClose))

        addTableView.setController(self)
        addTableView.loadInfo(sectionType)

        loadEntity()

        if sectionType == .addEvent || (sectionType == .category && !isNewEntity) {
            let buttonMenu = Button.systemButton("ellipsis")
            buttonMenu.addTarget(self, action: #selector(menuAction), for: .touchUpInside)

            navButtons.append(UIBarButtonItem(customView: buttonMenu))
        }

        title = getTitle()

        let image = Utils.system(isNewEntity ? "plus.circle.fill" : "square.and.pencil", pointSize: 20, weight: .bold)
        addEditButton.setImage(image, for: .normal)
        addEditButton.setTitle(isNewEntity || sectionType == .addWater ? "Добавить" : "Изменить", for: .normal)

        navigationItem.setRightBarButtonItems(navButtons, animated: true)
    }

    // MARK: - Actions

    @IBAction func addEditButtonAction(_ sender: Any) {
        switch sectionType {
        case .category:
            if let categories = categories {
                categories.colorId = nowSelectColor.getId()
                categories.imageId = nowSelectImage.getId()

                if isNewEntity {
                    self.categories = Categories.saveToBase(categories, nowSelectWaters)
                } else {
                    for selectWater in nowSelectWaters {
                        for water in categories.getWaters() {
                            print("water: \(water.getTitle()), \(water.getId()) | selectWater: \(selectWater.getTitle()), \(selectWater.getId())")
                            if water.id != selectWater.id {
                                water.categoriesId = -1
                            }
                        }

                        selectWater.categoriesId = categories.id ?? -1
                    }

                    CoreDataManager.instance.saveContext()
                }
            }
            addDelegate?.saveCategories(categories, isNewEntity)
        case .addWater, .editWater:
            if let water = water {
                water.colorId = nowSelectColor.getId()
                water.imageId = nowSelectImage.getId()
                water.categoriesId = nowSelectCategory?.id ?? -1
                if isNewEntity {
                    self.water = Water.saveToBase(water)
                } else {
                    CoreDataManager.instance.saveContext()
                }
            }

            addDelegate?.saveWater(water, isNewEntity)
        default:
            if let event = event {
                event.waterId = water?.id ?? -1

                if isNewEntity {
                    self.event = Event.saveToBase(event)
                } else {
                    CoreDataManager.instance.saveContext()
                }
            }

            addDelegate?.saveEvent(event)
        }

        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Additional functions
    func getTitle() -> String {
        var title = ""

        switch sectionType {
        case .category:
            title = isNewEntity ? "Новая категория" : "Изменить"
        case .addWater, .editWater:
            title = isNewEntity ? "Новый напиток" : "Изменить"
        default:
            title = "Добавить"
        }

        return title
    }

    func loadEntity() {
        switch sectionType {
        case .category:
            if categories == nil {
                categories = Categories(entity: CoreDataManager.instance.entityForName(entityName: "Categories"), insertInto: nil)
                categories?.imageId = nowSelectImage.getId()
                categories?.colorId = nowSelectColor.getId()

                isNewEntity = !isNewEntity
            }

            addTableView?.loadCategory(categories)
        case .addWater, .editWater:
//            event = water?.getEvent()

            if water == nil {
                water = Water(entity: CoreDataManager.instance.entityForName(entityName: "Water"), insertInto: nil)
                water?.imageId = nowSelectImage.getId()
                water?.colorId = nowSelectColor.getId()

                if event == nil {
                    event = Event(entity: CoreDataManager.instance.entityForName(entityName: "Event"), insertInto: nil)
                    event?.water = water
                }

                isNewEntity = !isNewEntity
            }

            addTableView?.loadWater(water, event)
        default:
            if event == nil {
                event = Event(entity: CoreDataManager.instance.entityForName(entityName: "Event"), insertInto: nil)

                if water == nil {
                    water = Water(entity: CoreDataManager.instance.entityForName(entityName: "Water"), insertInto: nil)
                    water?.imageId = nowSelectImage.getId()
                    water?.colorId = nowSelectColor.getId()
                }

                event?.water = water

                isNewEntity = !isNewEntity
            }
            addTableView?.loadWater(water, event)
        }
    }

    @objc func menuAction() {
        dismissKeyboard()

        if sectionType == .category {
            dialogDeleteMessage(true)
            return
        }
        var titleWater = ""

        if let water = water {
            titleWater = " «\(water.getTitle())»"
        }

        let dialogMessage = UIAlertController(title: "Что сделать с напитком\(titleWater)?", message: nil, preferredStyle: .actionSheet)

        let edit = UIAlertAction(title: "Изменить", style: .default, handler: { (action) -> Void in
            self.sectionType = .editWater
            self.isNewEntity = !self.isNewEntity
            self.initSettings()
        })

        let delete = UIAlertAction(title: "Удалить", style: .destructive) { (action) -> Void in
            self.dialogDeleteMessage()
        }

        let cancel = UIAlertAction(title: "Отменить", style: .cancel)

        dialogMessage.addAction(edit)
        dialogMessage.addAction(delete)
        dialogMessage.addAction(cancel)
        dialogMessage.view.tintColor = #colorLiteral(red: 0.2748280764, green: 0.4806137681, blue: 1, alpha: 1)

        self.present(dialogMessage, animated: true, completion: nil)
    }

    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

    func dialogDeleteMessage(_ isCategory: Bool = false) {
        let dialogMessage = UIAlertController(title: isCategory ?
            "Удалятся все напитки принадлежащие этой категории. Данные не будут учитываться в статистике." :
            "Удалятся все данные принадлежащие этому напитку.", message: nil, preferredStyle: .actionSheet)

        let deleteAll = UIAlertAction(title: "Удалить категорию и напитки", style: .destructive, handler: { (action) -> Void in
            self.delete(true)
        })

        let delete = UIAlertAction(title: isCategory ? "Удалить только категорию" : "Удалить напиток", style: .destructive) { (action) -> Void in
            print("delete button click...")
            self.delete()
        }

        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }

        if isCategory {
            dialogMessage.addAction(deleteAll)
        }

        dialogMessage.addAction(delete)
        dialogMessage.addAction(cancel)
        dialogMessage.view.tintColor = #colorLiteral(red: 0.2748280764, green: 0.4806137681, blue: 1, alpha: 1)

        self.present(dialogMessage, animated: true, completion: nil)
    }

    func delete(_ isAllDelete: Bool = false) {
        if isAllDelete {
            if let categories = categories {
                let waters = categories.getWaters()
                for water in waters {
                    let events = water.getEvents()
                    CoreDataManager.removeCollection(events)
                }
                CoreDataManager.removeCollection(waters)
                CoreDataManager.instance.context.delete(categories)
            }
        } else {
            switch sectionType {
            case .category:
                if let categories = categories {
                    let waters = categories.getWaters()
                    waters.forEach({ $0.categoriesId = -1 })
                    CoreDataManager.instance.context.delete(categories)
                }
            case .addEvent:
                if let water = water {
                    let events = water.getEvents()
                    CoreDataManager.removeCollection(events)
                    CoreDataManager.instance.context.delete(water)
                }
            default:
                if let event = event {
                    CoreDataManager.instance.context.delete(event)
                }
            }
        }

        CoreDataManager.instance.saveContext()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
           return self.lightStatusBar ? .lightContent : .default
    }
}

extension AddViewController: WaterCollectionViewControllerDelegate {
    func selectWaters(_ waters: [Water]) {
        nowSelectWaters = waters
    }

    func selectWater(_ water: Water?, edit: Bool) {
        rootController?.selectWater(water, edit: edit)
    }
}

extension AddViewController: ColorsCollectionViewControllerDelegate {
    func selectColor(_ newColor: WaterColor) {
        nowSelectColor = newColor
    }
}

extension AddViewController: CategoriesCollectionViewControllerDelegate {
    func selectCategories(_ category: Categories?) {
       nowSelectCategory = category
    }
}

extension AddViewController: IconsCollectionViewControllerDelegate {
    func selectIcon(_ newIcon: WaterImage) {
        nowSelectImage = newIcon
    }
}

extension AddViewController: SPStorkControllerConfirmDelegate {
    var needConfirm: Bool {
        return false
    }

    func confirm(_ completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Need dismiss?", message: "It test confirm option for SPStorkController", preferredStyle: .actionSheet)
        alertController.addDestructiveAction(title: "Confirm", complection: {
            completion(true)
        })
        alertController.addCancelAction(title: "Cancel") {
            completion(false)
        }
        self.present(alertController)
    }
}
