//
//  BackgroundManager.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 07/08/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation

class BackgroundManager {
    
    func scheduleNotification(completionHandler: (UIBackgroundFetchResult) -> Void) {
        println("Schedule notification")
        
        if let notfication = Notification.get() {
            
            var status = UIBackgroundFetchResult.NoData

            // TODO: Make this config based
            if !notfication.hasScheduledEarlyDayNotifcation() {
                let date = NSDate()
                let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)

                if let newDate = cal?.startOfDayForDate(date) {
                    
                    let dateTimeToScheduleNotifictaion0900 = newDate.dateByAddingTimeInterval(NSTimeInterval(60*60 * 9))
                    
                    var text: String
                    var day: String
                    var backgroundName: String?
                    
                    (text, day, backgroundName) = DayService.getEarlyDayScreen()
                    LocalNotificationService.createUiLocalNotification(dateTimeToScheduleNotifictaion0900, title: day, body: text)
                    notfication.sethasScheduledEarlyDayNotifcation()
                    status = UIBackgroundFetchResult.NewData
                }
            }
            if !notfication.hasScheduledLateDayNotification() {
                let date = NSDate()
                let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
                
                if let newDate = cal?.startOfDayForDate(date) {
                    let dateTimeToScheduleNotifictaion2100 = newDate.dateByAddingTimeInterval(NSTimeInterval(60*60 * 21))
                
                    var text: String
                    var day: String
                    var backgroundName: String?
                    
                    (text, day, backgroundName) = DayService.getEarlyDayScreen()
                    LocalNotificationService.createUiLocalNotification(dateTimeToScheduleNotifictaion2100, title: day, body: text, category: notificationCategoryIdent)
                    notfication.sethasScheduledLateDayNotification()
                    status = UIBackgroundFetchResult.NewData
                }
            }
            
            notfication.save()
            completionHandler(status)
            return
        }
        // Call completion handler with success
        completionHandler(UIBackgroundFetchResult.NewData)
    }
}