//
//  DBEntity.swift
//  CoreDataKit
//
//  Created by nik on 28.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import CoreData

public class DBEntity: NSManagedObject {
    
    convenience init(entity: String) {
        self.init(entity: entity, shouldGenerateId: true, shouldGeneratePosition: false)
    }
    
    convenience init(entity: String, shouldGenerateId: Bool,shouldGeneratePosition: Bool) {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: entity), insertInto: CoreDataManager.instance.context)
        
        if (shouldGenerateId) {
            self.id = DBEntity.generate(entity: entity, key: "id") as NSNumber?
        }
        
        if (shouldGeneratePosition) {
            self.position = DBEntity.generate(entity: entity, key: "position") as NSNumber?
        }
    }
    
    static public func generate(entity: String, key: String) -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: key, ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            let items = fetchedResultsController.fetchedObjects as! [DBEntity]
            
            switch key {
            case "id":
                return items.isEmpty ? 1 : Int(truncating: items[0].id!) + 1
            case "position":
                return items.isEmpty ? 1 : Int(truncating: items[0].position!) + 1
            default:
                return -1
            }
        } catch {
            print(error)
            return -1
        }
    }
}

extension DBEntity {
    @NSManaged public var id: NSNumber?
    @NSManaged public var position: NSNumber?
}
