//
//  Requests.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import Foundation
import Alamofire

class Requests {
    
    
    static let link = "http://red.maxcode.net/api/clocks"
    
    static let token = "f1ca6a02-e09f-4d92-977f-69607bd06d59"
    
    //        print("338fc045-bff0-4ee7-8340-cb50a342cf99")
    
    static func getAlarms(completion: @escaping ([Alarm]) -> ()) {

        let header = [ "x-token": token]
        let url = URL(string: link)!
        
        Alamofire.request(url, method: .get, parameters: [:], headers: header).responseJSON { response in
            
            if let result = response.result.value {
                
                guard let alarms = result as? Array<Dictionary<String,Any>>, alarms.count != 0 else {
                    completion([])
                    return
                }
                
                completion(parseAlarms(alarmsDict: alarms))
            
            } else {
                completion([])
            }
        }
    }
    
    static func parseAlarms(alarmsDict: Array<Dictionary<String,Any>>) -> [Alarm] {
        
        var alarms = [Alarm]()
        
        for alarm in alarmsDict {
            
            guard let id = alarm["id"] as? Int else {return alarms}
            guard let label = alarm["label"] as? String else {return alarms}
            guard let hour = alarm["hour"] as? Int else {return alarms}
            guard let minute = alarm["minutes"] as? Int else {return alarms}
            guard let enabled = alarm["enabled"] as? Bool else {return alarms}
            
            alarms.append(Alarm(id: id, label: label, hour: hour, minute: minute, isEnabled: enabled, weekdays: ["", "", "", "", "", "", ""]))
        }
        
        return alarms
    }
    
    static func postAlarm(label: String, hour: Int, minute: Int, completion: @escaping (Alarm?) -> ()) {
        
        let header = [ "x-token": token]
        let parameters: Parameters = ["label": label, "hour": hour, "minutes": minute, "enabled": true]
        let url = URL(string: link)!
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            if let result = response.result.value {
               
                guard let alarm = result as? Dictionary<String,Any> else {
                    completion(nil)
                    return
                }
                
                guard let id = alarm["id"] as? Int else {completion(nil); return}
                guard let label = alarm["label"] as? String else {completion(nil); return}
                guard let hour = alarm["hour"] as? Int else {completion(nil); return}
                guard let minute = alarm["minutes"] as? Int else {completion(nil); return}
                guard let enabled = alarm["enabled"] as? Bool else {completion(nil); return}
                
                completion(Alarm(id: id, label: label, hour: hour, minute: minute, isEnabled: enabled, weekdays: ["", "", "", "", "", "", ""]))
                
            } else {
                completion(nil)
            }
        }
    }
    
    static func updateAlarm(id: Int, label: String, hour: Int, minute: Int, enabled: Bool, completion: @escaping (Alarm?) -> ()) {
        
        let header = [ "x-token": token]
        let parameters: Parameters = ["label": label, "hour": hour, "minutes": minute, "enabled": enabled]
        
        let url = URL(string: link + "/?id=\(id)")!
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            
            if let result = response.result.value {
                
                guard let alarm = result as? Dictionary<String,Any> else {
                    completion(nil)
                    return
                }
                
                guard let id = alarm["id"] as? Int else {completion(nil); return}
                guard let label = alarm["label"] as? String else {completion(nil); return}
                guard let hour = alarm["hour"] as? Int else {completion(nil); return}
                guard let minute = alarm["minutes"] as? Int else {completion(nil); return}
                guard let enabled = alarm["enabled"] as? Bool else {completion(nil); return}
                
                completion(Alarm(id: id, label: label, hour: hour, minute: minute, isEnabled: enabled, weekdays: ["", "", "", "", "", "", ""]))
                
            } else {
                completion(nil)
            }
        }
    }
    
    static func deleteAlarm(id: Int, completion: @escaping (Bool) -> ()) {
        
        let header = [ "x-token": token]
        let parameters: Parameters = ["id": id]
        
        let url = URL(string: link)!
        
        Alamofire.request(url, method: .delete, parameters: parameters, headers: header).responseData { (data) in
            
            switch data.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
}
