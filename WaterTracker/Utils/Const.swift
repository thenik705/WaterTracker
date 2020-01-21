//
//  Const.swift
//  WaterTracker
//
//  Created by nik on 20.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import UIKit

class Const {

    // MARK: - Controller
    static var GET_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)

    static var MAIN_VIEW_CONTROLLER = "MAIN_VIEW_CONTROLLER"
    static var ADD_VIEW_CONTROLLER = "ADD_VIEW_CONTROLLER"
    static var SETTINGS_VIEW_CONTROLLER = "SETTINGS_VIEW_CONTROLLER"

    // MARK: - Settings
    static var APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

    // MARK: - KeyNotification
    static var STATUS_CONNECTED = "STATUS_CONNECTED"
    static var FIRST_START = "FIRST_START"
    static var FULL_VERSION = "FULL_VERSION"
    static var FULL_PLUS_VERSION = "FULL_PLUS_VERSION"
    static var FULL_ULTIMATE_VERSION = "FULL_ULTIMATE_VERSION"
    static var DATE_PLUS_VERSION = "DATE_PLUS_VERSION"
    static var START_DAY_USER = "START_DAY_USER"

    // MARK: - Config
    static var MAX_CATEGORIES_COUNT = 3
    static var MAX_WATER_COUNT = 7
    static var MAX_TEXT_COUNT = 50

    static var GROUP_ID = "group.com.nik.water.traker.container"

    // MARK: - IAPProducts
    // MARK: - URL
    // MARK: - Sount Name
    
    static var SOUND_DONE = "nano/3rdParty_Success_Haptic.caf"//4798 4899 4912 5190
    //5201
    
    // MARK: - Sort BD
    static var SORT_ID = [NSSortDescriptor(key: "id", ascending: true)]
    static var SORT_POSITION = [NSSortDescriptor(key: "position", ascending: false)]

    // MARK: - AnalyticsKey
}
