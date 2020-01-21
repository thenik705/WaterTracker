//
//  GenerateWaters.swift
//  WaterTracker
//
//  Created by nik on 12.12.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class GenerateWaters {

    static let Water1 = GenerateWaters("Газировка", GenerateCategories.Water.getId(), WaterColor.GreenBlue.getId(), WaterImage.imageDefault.getId())
    static let Water2 = GenerateWaters("Газировка", GenerateCategories.Water.getId(), WaterColor.GreenBlue.getId(), WaterImage.imageDefault.getId())

    static let Coffe1 = GenerateWaters("Какао", GenerateCategories.Coffe.getId(), WaterColor.Grey.getId(), WaterImage.imageDefault.getId())
    static let Coffe2 = GenerateWaters("Латте", GenerateCategories.Coffe.getId(), WaterColor.Grey.getId(), WaterImage.imageDefault.getId())

    static let Tea1 = GenerateWaters("Чёрный чай", GenerateCategories.Tea.getId(), WaterColor.Grey.getId(), WaterImage.imageDefault.getId())

    static let Milk = GenerateWaters("Молоко", -1, WaterColor.Red.getId(), WaterImage.imageDefault6.getId())

    static func values() -> [GenerateWaters] {
        return [Milk, Tea1, Coffe2, Coffe1, Water2, Water1]
    }

    var title: String
    var colorId: String
    var imageId: String
    var categoriesId: Int

    fileprivate init(_ title: String, _ categoriesId: Int, _ colorId: String, _ imageId: String) {
        self.title = title
        self.categoriesId = categoriesId
        self.colorId = colorId
        self.imageId = imageId
    }

    func getTitle() -> String {
        return title.localized()
    }
}
