//
//  WaterHelpers.swift
//  WaterTracker
//
//  Created by nik on 11.12.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import CoreDataKit

class WaterHelpers {
    static let instance = WaterHelpers()

     var maxVolumeDay = 0.0

    var events = [Event]()
    var progress = 0.0
    var allVolume = 0.0
    var selectDay = Date()

    init() {
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func notify() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "eventChanged"), object: nil)
    }

    func loadEventDay(_ maxVolume: Double = 0.0, _ day: Date = Date()) {
        clear()

        selectDay = day

        maxVolumeDay = maxVolume
        events = CoreDataManager.loadEventsToDate(day)
        updateInfo()
    }

    func addEvent(_ newEvent: Event) {
        events.append(newEvent)
        updateInfo()
    }

    func delete(_ position: Int) {
        events.remove(at: position)
        updateInfo()
    }

    func updateInfo() {
        allVolume = getVolume()
        progress = getProgress()

        notify()
    }

    func getVolume() -> Double {
        var allVolume = 0.0

        for event in events {
            if let volumeEvent = Double(event.volume) {
                let volumeProgress = volumeEvent * 1
                let percent = (volumeProgress/maxVolumeDay)*100.0

                event.percent = percent.rounded()
                allVolume += volumeProgress
            }
        }

        return allVolume
    }

    func getProgress() -> Double {
        var progress = 0.0

        if allVolume != 0.0 {
            progress = (allVolume/maxVolumeDay)*100.0
        }

        return progress
    }

    func getProgreeEvents(_ events: [Event]) -> Double {
        var progress = 0.0
        var allVolume = 0.0

        for event in events {
            if let volumeEvent = Double(event.volume) {
                allVolume += volumeEvent * 1
            }
        }

        if allVolume != 0.0 {
            progress = (allVolume/maxVolumeDay)*100.0
        }

        return progress
    }

    func clear() {
        events.removeAll()
        progress = 0.0
        allVolume = 0.0
    }
}
