//
//  WaterImage.swift
//  WaterTracker
//
//  Created by Nik on 30.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

public class WaterImage {

    static public let imageDefault = WaterImage("test1", image: UIImage(named: "test1")!)
    static public let imageDefault1 = WaterImage("test2", image: UIImage(named: "test2")!)
    static public let imageDefault2 = WaterImage("test3", image: UIImage(named: "test3")!)
    static public let imageDefault3 = WaterImage("test4", image: UIImage(named: "test4")!)
    static public let imageDefault4 = WaterImage("test5", image: UIImage(named: "test5")!)
    static public let imageDefault5 = WaterImage("test6", image: UIImage(named: "test6")!)
    static public let imageDefault6 = WaterImage("test7", image: UIImage(named: "test7")!)
    static public let imageDefault7 = WaterImage("clear.fill", image: UIImage(systemName: "clear.fill")!)
    static public let imageDefault8 = WaterImage("doc.text.fill", image: UIImage(systemName: "doc.text.fill")!)
    static public let imageDefault9 = WaterImage("cloud.sun.fill", image: UIImage(systemName: "cloud.sun.fill")!)
    static public let imageDefault10 = WaterImage("cloud.moon.fill", image: UIImage(systemName: "cloud.moon.fill")!)
    static public let imageDefault11 = WaterImage("play.fill", image: UIImage(systemName: "play.fill")!)

    static public func values() -> [WaterImage] {
        return [imageDefault, imageDefault1, imageDefault2, imageDefault3, imageDefault4, imageDefault5, imageDefault6, imageDefault7, imageDefault8, imageDefault9, imageDefault10, imageDefault11]
    }

    static public func getById(_ itemId: String) -> WaterImage {
        let result = values().filter({ $0.itemId == itemId }).first
        return result ?? imageDefault
    }

    public var itemId: String
    public var image: UIImage

    private init(_ itemId: String, image: UIImage) {
        self.itemId = itemId
        self.image = image
    }

    public func getId() -> String {
        return itemId
    }

    public func getImage() -> UIImage {
        return image
    }
}
