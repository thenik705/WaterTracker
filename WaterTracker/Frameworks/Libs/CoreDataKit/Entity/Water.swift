//
//  Water.swift
//  CoreDataKit
//
//  Created by Nik on 30.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import UIKit
import CoreData

public class Water: DBEntity, ITitle {
    
    @NSManaged public var colorId: String?
    @NSManaged public var imageId: String?
    @NSManaged public var title: String?
    @NSManaged public var categoriesId: NSNumber
    
    public var categories: Categories?
    public var event: Event?
    
    convenience init() {
        self.init(entity: "Water", shouldGenerateId: true, shouldGeneratePosition: true)
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
    
    public func getCategories() -> Categories? {
        if (self.categories == nil) {
            self.categories = CoreDataManager.loadFromDbById(clazz: Categories.self, id: String(describing: self.categoriesId))
        }
        return categories
    }
    
    public func getEvents() -> [Event] {
       return CoreDataManager.loadFromDbByItems(clazz: Event.self, itemField: "waterId", itemParametr: "\(self.id!)")
    }
    
    static public func saveToBase(_ water: Water) -> Water {
        let newWater = Water()
        newWater.colorId = water.colorId
        newWater.imageId = water.imageId
        newWater.title = water.title
        newWater.categoriesId = water.categoriesId
        CoreDataManager.instance.saveContext()
        
        return newWater
    }
    
    override public func didChangeValue(forKey key: String) {
        if "categoriesId" == key {
            categories = nil
        } else if "projectId" == key {
            event = nil
        }
    }
}
