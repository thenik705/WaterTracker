//
//  SettingsSections.swift
//  WaterTracker
//
//  Created by nik on 05.01.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import Foundation

class SettingsSections {

    static public let Proffile = SettingsSections(SectionEntity.Proffile.getId(), [SettingsSectionsEntity.Proffile])

    static public let Premium = SettingsSections(SectionEntity.Premium.getId(), [SettingsSectionsEntity.Premium, SettingsSectionsEntity.Benefits])

    static public let AppInfo = SettingsSections(SectionEntity.AppInfo.getId(), [SettingsSectionsEntity.Appearance, SettingsSectionsEntity.Notifications, SettingsSectionsEntity.Password, SettingsSectionsEntity.Language])

    static public let Support = SettingsSections(SectionEntity.Support.getId(), [SettingsSectionsEntity.Feedback, SettingsSectionsEntity.Email, SettingsSectionsEntity.Chat, SettingsSectionsEntity.Chat])

    static public let AboutApp = SettingsSections(SectionEntity.AboutApp.getId(), [SettingsSectionsEntity.About])

    static public func allValues() -> [SettingsSections] {
        return [Proffile, Premium, AppInfo, Support, AboutApp]
    }

    var itemId: Int
    var childrens: [SettingsSectionsEntity]
    var subTitle: String

    init(_ itemId: Int, _ childrens: [SettingsSectionsEntity], _ subTitle: String = "") {
        self.itemId = itemId
        self.childrens = childrens
        self.subTitle = subTitle
    }

    static public func byId(_ itemId: Int) -> SettingsSections? {
        return allValues().first(where: { $0.itemId == itemId })
    }

     func count() -> Int {
        return childrens.count
    }
}
