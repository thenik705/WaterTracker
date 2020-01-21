//
//  Events.swift
//  CoreDataKit
//
//  Created by nik on 28.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import CoreData
import DateUtilsKit

public class Event: DBEntity, ITitle {

    @NSManaged public var dateTaken: String?
    @NSManaged public var waterId: NSNumber
    @NSManaged public var volume: String
    
    public var categories: Categories?
    public var water: Water?
    public var percent: Double = 0.0
    
    convenience init() {
        self.init(entity: "Event")
    }
    
    public func getStrVolume() -> String {
        return volume
    }
    
    public func getVolume() -> Double {
        return Double(volume) as! Double
    }
    
    public func getCategories() -> Categories? {
        if (self.categories == nil) {
            self.categories = getWater()?.categories
        }
        return categories
    }
    
    public func getWater() -> Water? {
        if (self.water == nil) {
            self.water = CoreDataManager.loadFromDbById(clazz: Water.self, id: String(describing: self.waterId))
        }
        return water
    }
    
    public func getTitle() -> String {
        return getWater()?.getTitle() ?? ""
    }
    
    public func getId() -> NSObject {
        return id ?? -1
    }
    
    override public func didChangeValue(forKey key: String) {
        if "waterId" == key {
            water = nil
        }
    }
    
    static public func saveToBase(_ event: Event) -> Event {
        let newEvent = Event()
        newEvent.dateTaken = DateUtils.dateFormatterTime(Date())
        newEvent.waterId = event.waterId
        newEvent.volume = event.volume
        CoreDataManager.instance.saveContext()
        
        return newEvent
    }
}
