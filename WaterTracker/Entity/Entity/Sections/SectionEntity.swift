//
//  SectionEntity.swift
//  WaterTracker
//
//  Created by nik on 02.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class SectionEntity {
//    static public let Substrate = SectionEntity(id: -1, title: "Substrate", isHidden: true)
    static public let Header = SectionEntity(0, title: "Header", isHidden: true)
    static public let Calendar = SectionEntity(1, title: "Calendar", isHidden: true)
    static public let AddEntity = SectionEntity(2, title: "AddEntity", isHidden: true)
    static public let Progress = SectionEntity(3, title: "Progress", isHidden: true)
    static public let Categories = SectionEntity(4, title: "Категории", isShowAll: true)
    static public let Waters = SectionEntity(5, title: "Напитки", isShowAll: true)
    static public let History = SectionEntity(6, title: "История")
    static public let Preview = SectionEntity(7, title: "Preview", isHidden: true)
    static public let Title = SectionEntity(8, title: "Название")
    static public let Count = SectionEntity(9, title: "Объем", subTitle: "Введите сколько Вы выпили")
    static public let Color = SectionEntity(10, title: "Цвет", subTitle: "Используется в графиках")
    static public let Icons = SectionEntity(11, title: "Иконка", subTitle: "Для ")
    static public let Actions = SectionEntity(12, title: "Дейсвия")
    static public let Proffile = SectionEntity(13, title: "Профиль", isHidden: true)
    static public let Premium = SectionEntity(14, title: "Премиум", isHidden: true)
    static public let AppInfo = SectionEntity(15, title: "Приложение")
    static public let Support = SectionEntity(16, title: "Поддержка", subTitle: "Чат доступен только активным пользователям. Присодиняйтесь.")
    static public let AboutApp = SectionEntity(17, title: "О приложении", isHidden: true)

    static public func allValues() -> [SectionEntity] {
        return [Header, Calendar, AddEntity, Progress, Categories, Waters, History, Actions, Preview, Title, Count, Color, Icons, Proffile, Premium, AppInfo, Support, AboutApp]
    }

    static public func mainValues() -> [SectionEntity] {
        return [Header, Calendar, Progress, Categories, Waters, History, Actions]
    }

    static public func addValues() -> [SectionEntity] {
        return [Preview, Title, Color, Icons]
    }

    static public func addEventValues() -> [SectionEntity] {
        return [Preview, Title, Count]
    }

    static public func settingsValues() -> [SectionEntity] {
        return [Proffile, Premium, AppInfo, Support, AboutApp]
    }

    static public func getValues(_ sectionType: SectionType = .main) -> [SectionEntity] {
        return values(sectionType)
    }

    static public func getAddValuesIndex(_ sectionType: SectionType = .addWater, _ type: SectionEntity) -> Int {
        let typeValues = values(sectionType)
        return typeValues.firstIndex(where: { $0.itemId == type.itemId }) ?? 0
    }

    public var itemId: Int
    public var title: String
    public var subTitle: String?
    public var emptyTitle: String
    public var emptySubTitle: String
    public var isHidden: Bool
    public var isShowAll: Bool

    fileprivate init(_ itemId: Int, title: String, subTitle: String? = nil, emptyTitle: String = "", emptySubTitle: String = "", isHidden: Bool = false, isShowAll: Bool = false) {
        self.itemId = itemId
        self.title = title
        self.subTitle = subTitle
        self.emptyTitle = emptyTitle
        self.emptySubTitle = emptySubTitle
        self.isHidden = isHidden
        self.isShowAll = isShowAll
    }

    static public func byId(_ itemId: Int) -> SectionEntity? {
        return allValues().first(where: { $0.itemId == itemId })
    }

    static public func byTitle(_ title: String) -> SectionEntity? {
        return allValues().first(where: { $0.title == title })
    }

    static public func values(_ sectionType: SectionType = .main) -> [SectionEntity] {
        var volues = addValues()

        switch sectionType {
        case .main:
            volues = mainValues()

            let progress = volues.first(where: { $0.itemId == Progress.getId() })
            progress?.emptySubTitle = "Нет данных о напитках"

            let history = volues.first(where: { $0.itemId == History.getId() })
            history?.emptyTitle = "Пусто"
            history?.emptySubTitle = "Нет последних напитков"
        case .addWater:
            if let indexCount = volues.firstIndex(where: { $0.itemId == Title.itemId }) {
                volues.insert(Count, at: indexCount+1)
                volues.insert(Categories, at: volues.count)
            }
        case .addWater, .editWater:
            if let indexCount = volues.firstIndex(where: { $0.itemId == Title.itemId }) {
                if sectionType == .addWater {
                    volues.insert(Count, at: indexCount+1)
                }

                volues.insert(Categories, at: volues.count)
            }
        case .category:
             volues.insert(Waters, at: volues.count)
        case .addEvent:
            return addEventValues()
        case .settings:
            return settingsValues()
        case .welcomeSettings:
            volues = addEventValues()

            let title = volues.first(where: { $0.itemId == Title.getId() })
            title?.title = "Ваше имя"

            let count = volues.first(where: { $0.itemId == Count.getId() })
            count?.title = "Ваш вес"
            count?.subTitle = "Введите сколько Вы весите"

        default:
            print("NO SectionType!")
        }

        return volues
    }

    func setTitle(_ title: String) {
        self.title = title
    }

    func setSubTitle(_ subTitle: String) {
        self.subTitle = subTitle
    }

    public func getId() -> Int {
        return itemId
    }

    public func getTitle() -> String {
        return title
    }

    public func getSubTitle() -> String {
        return subTitle ?? ""
    }

    public func getIsShowAll() -> Bool {
        return isShowAll
    }

    public func getIsHidden() -> Bool {
        return isHidden
    }

    static public func getTitleCell(_ itemId: Int) -> Int {
        switch itemId {
        case SectionEntity.Proffile.itemId:
            return 1
        case SectionEntity.Premium.itemId:
            return 2
        case SectionEntity.AppInfo.itemId:
            return 4
        case SectionEntity.Support.itemId:
            return 3
        case SectionEntity.AboutApp.itemId:
            return 1
        default:
            return 1
        }
    }
}
