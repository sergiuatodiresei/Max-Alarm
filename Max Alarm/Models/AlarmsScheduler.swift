//
//  AlarmsScheduler.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmsScheduler {
    
    static func createNotification(hour: Int, minute: Int, sound: String) {
        
        let content = UNMutableNotificationContent()
        
        content.body = "Alarm"
        
        if sound != "None" {
            if sound == "Apple" {
                content.sound = UNNotificationSound(named: "apple_ring.mp3")
            } else if sound == "Pineapple" {
                content.sound = UNNotificationSound(named: "pineapple_ring.mp3")
            } else {
                content.sound = UNNotificationSound(named: "watermelon_ring.mp3")
            }
        }
        
        let calendar = Calendar.current
        let components = DateComponents(hour: hour, minute: minute) // Set the date here when you want Notification
        let date = calendar.date(from: components)
        let comp = calendar.dateComponents([.hour,.minute], from: date!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
        
        let identifier = "\(hour):\(minute)"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    static func removeNotification(hour: Int, minute: Int) {
        
        let identifier = "\(hour):\(minute)"
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
}

