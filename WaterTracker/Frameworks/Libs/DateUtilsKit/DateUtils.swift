//
//  DateUtils.swift
//  DateUtilsKit
//
//  Created by nik on 01.11.2019.
//  Copyright © 2019 nik. All rights reserved.
//

import Foundation

public class DateUtils {
    
    static public func dateFormatterTime(_ date: Date) -> String {
        let dateClear = DateUtils.clearSeconds(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: dateClear)
    }
    
    static public func dateTimePicker(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static public func getTimeIntervalDate(_ date: Date?) -> Int {
        return date == nil ? 0 : Int(date!.timeIntervalSince1970)
    }
    
    static public func localeShortTime(_ fromDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: fromDate)
    }
    
    static public func getTimeString(_ time: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: time)!
    }
    
    static public func getReadableDate(_ date: Date, _ returnToday: String, _ returnTomorrow: String, _ returnYesterday: String) -> String {
        if Calendar.current.isDateInToday(date) {
            return returnToday
        } else if Calendar.current.isDateInTomorrow(date) {
            return returnTomorrow
        } else if Calendar.current.isDateInYesterday(date) {
            return returnYesterday
        } else {
            let dateYear = DateUtils.getParametersCount(date).year!
            let todayYear = DateUtils.getParametersCount(Date()).year!
            let format = dateYear == todayYear ? "MMM d" : "MMM d, yyyy"
            
            return setDateToFormat(date, toFormat: format)!
        }
    }
    
    static public func getTimeToday(_ date: Date) -> String? {
           return setDateToFormat(date, toFormat: "EEEE MMMM d")
       }
    
    static public func getTimeCalendar(_ date: Date) -> String? {
        return setDateToFormat(date, toFormat: "EE, MMM d")
    }
    
    static public func getDayNumberCalendar(_ date: Date) -> Int {
        return Int(setDateToFormat(date, toFormat: "d") ?? "0") ?? 0
    }
    
    static public func getDayCalendar(_ date: Date) -> String? {
        return setDateToFormat(date, toFormat: "MMMM d")
    }
    
    static public func setDateToFormat(_ date: Date, toFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: toFormat, options: 0, locale:  NSLocale.current)
        dateFormatter.timeZone = NSTimeZone.system
        
        return dateFormatter.string(from: date)
    }
    
    static public func clearTime(_ date: Date) -> Date {
        return setTimeToDate(date, hour: 0, minute: 0, seconds: 0)
    }
    
    static public func getDateEditMonth(_ date: Date, month: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: month, to: date)!
    }
    
    static public func dateFormatterCalendarDay(_ day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateStyle = .full
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: day as Date)
    }
    
    static public func clearSeconds(_ date: Date) -> Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return Calendar.current.date(from: dateComponents)!
    }
    
    static public func setYearToDate(_ date: Date, year: Int) -> Date {
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        component.year = year
        return  Calendar.current.date(from: component)!
    }
    
    static public func saveDateTo(date: Date, fromDate: Date) -> Date {
        let calendar = Calendar.current
        var newComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: fromDate)
        newComponents.day = components.day
        newComponents.month = components.month
        newComponents.year = components.year
        return calendar.date(from: newComponents)!
    }
    
    static public func saveTimeTo(date: Date, fromDate: Date) -> Date {
        let calendar = Calendar.current
        var newComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: fromDate)
        newComponents.hour = components.hour
        newComponents.minute = components.minute
        return calendar.date(from: newComponents)!
    }
    
    static public func setDateCalendarParams(year: Int, month: Int, day: Int) -> Date {
        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        component.year = year
        component.month = month
        component.day = day
        return Calendar.current.date(from: component)!
    }
    
    static public func setTimeToDate(_ date: Date, hour: Int, minute: Int, seconds: Int) -> Date {
        return Calendar.current.date(bySettingHour: hour, minute: minute, second: seconds, of: date)!
    }
    
    static public func getParametersCount(_ date: Date) -> DateComponents {
        return Calendar.current.dateComponents([.day, .month, .year, .weekOfYear, .hour, .minute, .second, .nanosecond], from: date)
    }
    
    static public func getWeekday() -> Int {
        let calendar = Calendar.current
        calendar.dateComponents([.day, .month, .weekday], from: Date())
        return calendar.firstWeekday
    }
    
    static public func getMaxMinDateCalendar(_ minYear: Int, _ maxYear: Int) -> (Date, Date) {
        let minDate = setDateCalendarParams(year: minYear, month: 01, day: 01)
        let maxDate = setDateCalendarParams(year: maxYear, month: 12, day: 31)
        
        return (minDate, maxDate)
    }
    
    static public func getHourMinuteDate(_ date: Date) -> (hour: Int, minute: Int) {
        let parametrs = getParametersCount(date)
        return (parametrs.hour ?? 0, parametrs.minute ?? 0)
    }
    
    static public func setHourDate(_ date: Date, _ hour: Int) -> Date {
        return setTimeToDate(date, hour: hour, minute: 0, seconds: 0)
    }
    
    static public func daysBetween(_ firstDate: Date, _ secondDate: Date) -> Int {
        let calendar = Calendar.current
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
    
    static public func getDayOfWeek(_ date: Date) -> Int {
        let calendar = Calendar.current
        var dayOfWeek = calendar.component(.weekday, from: date) + 1 - calendar.firstWeekday
        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }
        return dayOfWeek
    }
    
    static public func addYear(_ toDate: Date, years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: toDate)!
    }
    
    static public func addMonth(_ toDate: Date, months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: toDate)!
    }
    
    static public func addWeek(_ toDate: Date, weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfMonth, value: weeks, to: toDate)!
    }
    
    static public func addDays(_ toDate: Date, days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: toDate)!
    }
    
    static public func addHours(_ toDate: Date, hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: toDate)!
    }
    
    static public func addMinute(_ toDate: Date, minute: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minute, to: toDate)!
    }
}
