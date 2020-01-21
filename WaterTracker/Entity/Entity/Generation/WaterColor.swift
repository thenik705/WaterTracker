//
//  WaterColor.swift
//  WaterTracker
//
//  Created by Nik on 30.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit

class WaterColor {

    static public let Red = WaterColor("Red", index: 0, colors: [#colorLiteral(red: 0.9654200673, green: 0.1590853035, blue: 0.2688751221, alpha: 1),#colorLiteral(red: 0.7559037805, green: 0.1139892414, blue: 0.1577021778, alpha: 1)])
//    static public let OrangeRed = CategoriesColor("OrangeRed", colors: [#colorLiteral(red: 0.9338900447, green: 0.4315618277, blue: 0.2564975619, alpha: 1),#colorLiteral(red: 0.8518816233, green: 0.1738803983, blue: 0.01849062555, alpha: 1)])
    static public let Orange = WaterColor("Orange", index: 1, colors: [#colorLiteral(red: 0.9953531623, green: 0.54947716, blue: 0.1281470656, alpha: 1),#colorLiteral(red: 0.9409626126, green: 0.7209432721, blue: 0.1315650344, alpha: 1)])
    static public let Yellow = WaterColor("Yellow", index: 2, colors: [#colorLiteral(red: 0.9409626126, green: 0.7209432721, blue: 0.1315650344, alpha: 1),#colorLiteral(red: 0.8931249976, green: 0.5340107679, blue: 0.08877573162, alpha: 1)])
    static public let Green = WaterColor("Green", index: 3, colors: [#colorLiteral(red: 0.3796315193, green: 0.7958304286, blue: 0.2592983842, alpha: 1),#colorLiteral(red: 0.2060100436, green: 0.6006633639, blue: 0.09944178909, alpha: 1)])
    static public let GreenBlue = WaterColor("GreenBlue", index: 4, colors: [#colorLiteral(red: 0.2761503458, green: 0.824685812, blue: 0.7065336704, alpha: 1),#colorLiteral(red: 0, green: 0.6422213912, blue: 0.568986237, alpha: 1)])
    static public let KindaBlue = WaterColor("KindaBlue", index: 5, colors: [#colorLiteral(red: 0.2494148612, green: 0.8105323911, blue: 0.8425348401, alpha: 1),#colorLiteral(red: 0, green: 0.6073564887, blue: 0.7661359906, alpha: 1)])
    static public let SkyBlue = WaterColor("SkyBlue", index: 6, colors: [#colorLiteral(red: 0.3045541644, green: 0.6749247313, blue: 0.9517192245, alpha: 1),#colorLiteral(red: 0.008423916064, green: 0.4699558616, blue: 0.882807076, alpha: 1)])
    static public let Blue = WaterColor("Blue", index: 7, colors: [#colorLiteral(red: 0.1774400771, green: 0.466574192, blue: 0.8732826114, alpha: 1),#colorLiteral(red: 0.00491155684, green: 0.287129879, blue: 0.7411141396, alpha: 1)])
    static public let BluePurple = WaterColor("BluePurple", index: 8, colors: [#colorLiteral(red: 0.4613699913, green: 0.3118675947, blue: 0.8906354308, alpha: 1),#colorLiteral(red: 0.3018293083, green: 0.1458326578, blue: 0.7334778905, alpha: 1)])
    static public let Purple = WaterColor("Purple", index: 9, colors: [#colorLiteral(red: 0.7080290914, green: 0.3073516488, blue: 0.8653779626, alpha: 1),#colorLiteral(red: 0.5031493902, green: 0.1100070402, blue: 0.6790940762, alpha: 1)])
    static public let Pink = WaterColor("Pink", index: 10, colors: [#colorLiteral(red: 0.9495453238, green: 0.4185881019, blue: 0.6859942079, alpha: 1),#colorLiteral(red: 0.8123683333, green: 0.1657164991, blue: 0.5003474355, alpha: 1)])
    static public let Brown = WaterColor("Brown", index: 11, colors: [#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)])

    static public let Grey = WaterColor("Grey", index: 11, colors: [#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)])

    static public func values() -> [WaterColor] {
        return [Red, Orange, Yellow, Green, GreenBlue, KindaBlue, SkyBlue, Blue, BluePurple, Purple, Pink, Brown]
    }

    static public func getById(_ itemId: String) -> WaterColor {
        let color = values().filter({ $0.itemId == itemId }).first
        return color ?? SkyBlue
    }

    public var itemId: String
    public var index: Int
    public var colors = [UIColor]()

    fileprivate init(_ itemId: String, index: Int, colors: [UIColor]) {
        self.itemId = itemId
        self.index = index
        self.colors = colors
    }

    public func getId() -> String {
        return itemId
    }

    public func getColor() -> (UIColor, UIColor) {
        return (colors[0], colors[1])
    }

    public func getIndex() -> Int {
        return index
    }
}
