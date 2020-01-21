//
//  SettingsSectionsEntity.swift
//  WaterTracker
//
//  Created by nik on 05.01.2020.
//  Copyright © 2020 nik. All rights reserved.
//

import UIKit

class SettingsSectionsEntity {

    static public let Proffile = SettingsSectionsEntity(title: "Профиль", image: #imageLiteral(resourceName: "proffile"), color: #colorLiteral(red: 0.9792547822, green: 0.1750694215, blue: 0.34769997, alpha: 1))

    static public let Premium = SettingsSectionsEntity(title: "Премиум", image: #imageLiteral(resourceName: "premium"), color: #colorLiteral(red: 0.9792547822, green: 0.1750694215, blue: 0.34769997, alpha: 1))
    static public let Benefits = SettingsSectionsEntity(title: "Преимущества", image: #imageLiteral(resourceName: "power"), color: #colorLiteral(red: 0.9796057343, green: 0.2739924788, blue: 0.2439628541, alpha: 1))

    static public let Appearance = SettingsSectionsEntity(title: "Внешний вид", image: #imageLiteral(resourceName: "theme"), color: #colorLiteral(red: 0.3818911314, green: 0.3545758724, blue: 0.9170381427, alpha: 1))
    static public let Notifications = SettingsSectionsEntity(title: "Уведомления", image: #imageLiteral(resourceName: "notification"), color: #colorLiteral(red: 0.9796150327, green: 0.2740089297, blue: 0.2487690747, alpha: 1))
    static public let Password = SettingsSectionsEntity(title: "Пароль", image: #imageLiteral(resourceName: "lock"), color: #colorLiteral(red: 0.1911651194, green: 0.820818603, blue: 0.3558244705, alpha: 1))
    static public let Language = SettingsSectionsEntity(title: "Язык", image: #imageLiteral(resourceName: "lang"), color: #colorLiteral(red: 0.5610842109, green: 0.5573369265, blue: 0.5849413276, alpha: 1))

    static public let Feedback = SettingsSectionsEntity(title: "Оставить отзыв", image: #imageLiteral(resourceName: "heart"), color: #colorLiteral(red: 0.9792547822, green: 0.1750694215, blue: 0.34769997, alpha: 1))
    static public let Email = SettingsSectionsEntity(title: "Написать автору", image: #imageLiteral(resourceName: "mail"), color: #colorLiteral(red: 0.1498830616, green: 0.5226811767, blue: 0.9985530972, alpha: 1))
    static public let Chat = SettingsSectionsEntity(title: "Чат в телеграм", image: #imageLiteral(resourceName: "telegram"), color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))

    static public let About = SettingsSectionsEntity(title: "О приложении", image: #imageLiteral(resourceName: "home"), color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))

    static public func allValues() -> [SettingsSectionsEntity] {
        return [Proffile, Premium, Benefits, Appearance, Notifications, Language, Feedback, Email, Chat, About]
    }

    public var title: String
    public var image: UIImage
    public var color: UIColor

    fileprivate init(title: String, image: UIImage, color: UIColor) {
        self.title = title
        self.image = image
        self.color = color
    }
}
