//
//  FikeItems.swift
//  WaterTracker
//
//  Created by Nik on 25.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class GenerateCategories {

    static let Coffe = GenerateCategories(1, "Кофе", WaterColor.Brown.getId(), WaterImage.imageDefault1.getId())
    static let Tea = GenerateCategories(2, "Чай", WaterColor.Orange.getId(), WaterImage.imageDefault5.getId())
    static let Water = GenerateCategories(3, "Вода", WaterColor.Blue.getId(), WaterImage.imageDefault.getId())

    static func values() -> [GenerateCategories] {
        return [Coffe, Tea, Water]
    }

    var itemId: Int
    var title: String
    var colorId: String
    var imageId: String

    fileprivate init(_ itemId: Int, _ title: String, _ colorId: String, _ imageId: String) {
        self.itemId = itemId
        self.title = title
        self.colorId = colorId
        self.imageId = imageId
    }

    func getTitle() -> String {
        return title.localized()
    }
    
    func getId() -> Int {
        return itemId
    }
}
