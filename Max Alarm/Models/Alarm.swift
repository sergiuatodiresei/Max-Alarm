//
//  Alarm.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import Foundation

struct Alarm {
    
    var id: Int
    var label: String
    var hour: Int
    var minute: Int
    var isEnabled: Bool
    var weekdays: [String]
    var repeatTextAlarm: String {
        get {
            var i = 0, response = ""
            
            for day in weekdays {
                if day != "" {
                    i += 1
                    response += day.prefix(3) + " "
                }
            }
            
            if i == 0 {
                return ""
            }
            
            if i == 1 {
                for day in weekdays {
                    if day != "" {
                        return ", every " + day
                    }
                }
            }
            
            if i == 2 && weekdays[5] != "" && weekdays[6] != ""  {
                return ", every weekend"
            }
            
            if i == 5 && weekdays[5] == "" && weekdays[6] == ""  {
                return ", every weekday"
            }
            
            if i == 7 {
                return ", every day"
            }
            return ", " + response
        }
    }
    var repeatTextAddEditAlarm: String {
        get {
            var i = 0, response = ""
            
            for day in weekdays {
                if day != "" {
                    i += 1
                    response += day.prefix(3) + " "
                }
            }
            
            if i == 0 {
                return "Never"
            }
            
            if i == 1 {
                for day in weekdays {
                    if day != "" {
                        return "Every " + day
                    }
                }
            }
            
            if i == 2 && weekdays[5] != "" && weekdays[6] != ""  {
                return "Weekends"
            }
            
            if i == 5 && weekdays[5] == "" && weekdays[6] == ""  {
                return "Weekdays"
            }
            
            if i == 7 {
                return "Every Day"
            }
            
            return response
        }
    }
    
    
}

