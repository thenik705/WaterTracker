//
//  AppDelegate.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All r250ights reserved.
//

import UIKit
import CoreDataKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var firstStart = UserDefaults.standard.bool(forKey: Const.FIRST_START)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        CoreDataManager.instance.setGroupIdentifier(Const.GROUP_ID)

        print("---------------------------------------------------/n/n")
        print("Documen")
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!)
        print("GroupID")
        print(FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Const.GROUP_ID)!)
        print("---------------------------------------------------/n/n")

        if !(firstStart) {
            generateWaterType()

             UserDefaults.standard.set(true, forKey: Const.FIRST_START)
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func generateWaterType() {
        for category in GenerateCategories.values() {
            let newCategories = Categories()
            newCategories.title = category.getTitle()
            newCategories.imageId =  category.imageId
            newCategories.colorId =  category.colorId
        }

        for water in GenerateWaters.values() {
            let newWater = Water()
            newWater.title = water.getTitle()
            newWater.categoriesId = NSNumber(value: water.categoriesId)
            newWater.imageId =  water.imageId
            newWater.colorId =  water.colorId
        }

        CoreDataManager.instance.saveContext()
    }
}
