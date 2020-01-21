//
//  Day.swift
//  WaterTracker
//
//  Created by nik on 14.10.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation
import CoreDataKit

class Day {//: ITitle {

    static func values() -> [Day] {
        return Day.getAllDays()
    }

    var itemId: Int
    var name: String
    var date: Date
    var dayNumber: Int
    var progress: Double

    fileprivate init(_ itemId: Int, _ name: String, _ date: Date = Date(), _ dayNumber: Int = 0, _ progress: Double = 0.0) {
        self.itemId = itemId
        self.name = name
        self.date = date
        self.dayNumber = dayNumber
        self.progress = progress
    }

    func getId() -> Int {
        return itemId
    }

    func getTitle() -> String {
        return name//.localized()
    }

    func updateProgress() {
        progress = Day.getDayProgress(date)
    }

    static func getAllDays() -> [Day] {
        let startDay = UserDefaults.standard.integer(forKey: Const.START_DAY_USER)

        var days = [Day]()
        var beforeDays = [Day]()
        var afterDays = [Day]()

        for (index, day) in (Calendar.current.shortWeekdaySymbols).enumerated() {
            if Calendar.current.firstWeekday == 1 {
                days.append(Day(index == 0 ? 7 : index, day))
            } else {
                if index == 0 {
                    days.append(Day(7, day.capitalized))
                } else {
                    days.insert(Day(index, day.capitalized), at: 0)
                }
                days = days.sorted(by: { $0.itemId < $1.itemId })
            }
        }

        for day in days {
            if day.itemId == startDay || !afterDays.isEmpty {
                afterDays.append(day)
            } else {
                beforeDays.append(day)
            }
        }

        return startDay == 0 ? days : afterDays + beforeDays
    }

    static func getDayProgress(_ day: Date) -> Double {
        let events = CoreDataManager.loadEventsToDate(day)
        var allVolumeDay = 0.0

        for event in events {
            if let volumeEvent = Double(event.volume) {
                let newVolumeProgress = volumeEvent * 1
                allVolumeDay += newVolumeProgress
            }
        }

        let percent = allVolumeDay > 0 ? (allVolumeDay/WaterHelpers.instance.maxVolumeDay)*100.0 : 0.0
        return percent > 100.0 ? 100.0 : percent
    }
}

extension Int {
    var array: [Int] {
        return String(description).map {Int(String($0)) ?? 0}
    }
}
