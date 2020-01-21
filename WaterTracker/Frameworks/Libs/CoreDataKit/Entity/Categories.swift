//
//  WaterType.swift
//  CoreDataKit
//
//  Created by nik on 28.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreData

public class Categories: DBEntity, ITitle {
    
    @NSManaged public var colorId: String?
    @NSManaged public var imageId: String?
    @NSManaged public var title: String?

    convenience init() {
        self.init(entity: "Categories", shouldGenerateId: true, shouldGeneratePosition: true)
    }
    
    public func getTitle() -> String {
        return title ?? ""
    }
    
    public func getImageId() -> String {
        return imageId ?? ""
    }
    
    public func getColorId() -> String {
        return colorId ?? ""
    }
    
    public func getId() -> NSObject {
        return id ?? -1
    }
    
    public func getEvents(_ day: Date) -> [Event] {
        var events = [Event]()
        let allEventsDay = CoreDataManager.loadEventsToDate(day)
        
        for water in getWaters() {
            let waterEvents = allEventsDay.filter({ $0.waterId == water.id })
            events.append(contentsOf: waterEvents)
        }
        
        return events
    }
    
    public func getWaters() -> [Water] {
        return CoreDataManager.loadFromDbByItems(clazz: Water.self, itemField: "categoriesId", itemParametr: String(describing: getId()))
    }
    
    public func getTitleLastEvent() -> String {
        return ""
    }
    
    static public func saveToBase(_ categories: Categories, _ waters: [Water]) -> Categories {
        let newCategories = Categories()
        newCategories.colorId = categories.colorId
        newCategories.imageId = categories.imageId
        newCategories.title = categories.title
        
        for water in waters {
            water.categoriesId = newCategories.id ?? -1
        }
        
        CoreDataManager.instance.saveContext()
        
        return newCategories
    }
}

