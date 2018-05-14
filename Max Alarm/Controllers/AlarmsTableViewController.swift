//
//  AlarmsTableViewController.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmsTableViewController: UITableViewController  {
    
    @IBOutlet weak var darkModeBtn: UIBarButtonItem!
    
    var isDarkMode = false
    
    var activityIndicator: UIActivityIndicatorView!
    
    let userDefaults = UserDefaults.standard
    
    var alarms: [Alarm] = [Alarm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = self.view.center
        tableView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelectionDuringEditing = true
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        if userDefaults.bool(forKey: "isDarkMode") {
            darkModeEnabled()
        } else {
            darkModeDisabled()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled), name: .darkModeDisabled, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: .UIApplicationWillEnterForeground, object: nil)
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
        
    }
    
    @objc func appMovedToForeground() {
        checkIfArePendingNotificationRequests()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tryRequest()
    }
    
    func checkIfArePendingNotificationRequests(){
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            
            for (index, alarm) in self.alarms.enumerated() {
                
                if alarm.isEnabled {
                    
                    let time = "\(alarm.hour):\(alarm.minute)"
                    var alarmIsPending = false
                    for notif in notificationRequests {
                        
                        if notif.identifier == time {
                            alarmIsPending = true
                            break
                        }
                    }
                 
                    if !alarmIsPending {
                        
                        self.alarms[index].isEnabled = false
                        
                        Requests.updateAlarm(id: alarm.id, label: alarm.label, hour: alarm.hour, minute: alarm.minute, enabled: false, completion: { (_) in
                            print("Update alarm: ", alarm.id)
                        })
                        
                    }
                }
            }
            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func tryRequest(){
        
        if Connectivity.isConnectedToInternet() {
            
            Requests.getAlarms(completion: { (alarms) in
                
                self.alarms = alarms.sorted(by: {
                    if $0.hour != $1.hour {
                        return $0.hour < $1.hour
                    } else {
                        return $0.minute < $1.minute
                    }
                })
                
                self.checkIfArePendingNotificationRequests()

                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            })
           
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            let alertController = UIAlertController(title: "Eroare", message: "Nu există conexiune la internet", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            let retryAction = UIAlertAction(title: "Reîncearcă", style: .default, handler: { (alert) in
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                self.tryRequest()
            })
            alertController.addAction(retryAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isEditing {
            isEditing = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if alarms.count != 0 {
            TableViewHelper.WithoutMessage(viewController: self)
            self.navigationItem.leftBarButtonItem = editButtonItem
            return alarms.count
        }
        
        TableViewHelper.EmptyMessage(message: "No alarm", viewController: self)
        self.navigationItem.leftBarButtonItem = nil
        return alarms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCellID", for: indexPath) as! AlarmTableViewCell
        
        let alarm = alarms[indexPath.row]
        
        var stringHour = "\(alarm.hour)"
        var stringMinute = "\(alarm.minute)"
        
        if alarm.hour < 10 {
            stringHour = "0\(alarm.hour)"
        }
        
        if alarm.minute < 10 {
            stringMinute = "0\(alarm.minute)"
        }
        
        cell.timeLabel.text = stringHour + ":" + stringMinute
        cell.alarmLabel.text = alarm.label + alarm.repeatTextAlarm
        cell.selectionStyle = .none
        
        
        if isDarkMode {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            cell.alarmLabel.textColor = .white
            cell.timeLabel.textColor = .white
        } else {
            
            cell.backgroundColor = .clear
            cell.alarmLabel.textColor = .black
            cell.timeLabel.textColor = .black
            
        }
        
        let alarmSwitch = UISwitch()
        alarmSwitch.addTarget(self, action: #selector(didPressAlarmSwitch(_:)), for: .valueChanged)
        cell.accessoryView = alarmSwitch
        
        if alarm.isEnabled {
            
            alarmSwitch.setOn(true, animated: false)
            cell.timeLabel.alpha = 1
            cell.alarmLabel.alpha = 1
        } else {
            
            alarmSwitch.setOn(false, animated: false)
            cell.timeLabel.alpha = 0.7
            cell.alarmLabel.alpha = 0.7
            if !isDarkMode {
                cell.backgroundColor = UIColor.black.withAlphaComponent(0.03)
            }
        }
        
        cell.editingAccessoryType = .disclosureIndicator
        
        return cell
    }
    
    @objc func didPressAlarmSwitch(_ sender: UISwitch) {
        
        guard let indexPath = getCurrentCellIndexPath(sender) else {return}
        
        guard let cell = tableView.cellForRow(at: indexPath) as? AlarmTableViewCell else {return}
        
        if sender.isOn {
            
            cell.timeLabel.alpha = 1
            cell.alarmLabel.alpha = 1
        } else {
            cell.timeLabel.alpha = 0.7
            cell.alarmLabel.alpha = 0.7
            
            if !isDarkMode {
                cell.backgroundColor = UIColor.black.withAlphaComponent(0.03)
            }
        }
        
        let alarm = alarms[indexPath.row]
        
        if sender.isOn {
            
            Requests.updateAlarm(id: alarm.id, label: alarm.label, hour: alarm.hour, minute: alarm.minute, enabled: true, completion: { (updatedAlarm) in
                print("Update alarm: ", alarm.id)
                if let upAlarm = updatedAlarm {
                    self.alarms[indexPath.row].isEnabled = upAlarm.isEnabled
                    AlarmsScheduler.createNotification(hour: alarm.hour, minute: alarm.minute, sound: "Apple")
                }
            })
            
           
        } else {
            
            Requests.updateAlarm(id: alarm.id, label: alarm.label, hour: alarm.hour, minute: alarm.minute, enabled: false, completion: { (updatedAlarm) in
                print("Update alarm: ", alarm.id)
                if let upAlarm = updatedAlarm {
                    self.alarms[indexPath.row].isEnabled = upAlarm.isEnabled
                    AlarmsScheduler.removeNotification(hour: alarm.hour, minute: alarm.minute)
                }
            })
            
        }
        
    }
    
    func getCurrentCellIndexPath(_ sender: UISwitch) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
    
    @IBAction func didPressDarkModeBtn(_ sender: UIBarButtonItem) {
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "isDarkMode") {
            
            userDefaults.set(true, forKey: "isDarkMode")
            NotificationCenter.default.post(name: .darkModeEnabled, object: nil)
            
        } else {
            userDefaults.set(false, forKey: "isDarkMode")
            NotificationCenter.default.post(name: .darkModeDisabled, object: nil)
        }
        
        tableView.reloadData()
    }
    
    @objc private func darkModeEnabled() {
        
        isDarkMode = true
        darkModeBtn.image = #imageLiteral(resourceName: "ic_sun")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.orange
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        tableView.backgroundColor = UIColor.black
        
        tableView.reloadData()
    }
    
    @objc private func darkModeDisabled() {
        
        isDarkMode = false
        darkModeBtn.image = #imageLiteral(resourceName: "ic_moon")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.tintColor = .red
        
        UIApplication.shared.statusBarStyle = .default
        
        tableView.backgroundColor = .white
        
        tableView.reloadData()
    }
    
    @IBAction func didPressAddAlarmBtn(_ sender: UIBarButtonItem) {
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditAlarmViewControllerID") as! AddEditAlarmViewController
        
        viewController.alarm = Alarm(id: -1, label: "Alarm", hour: hour, minute: minute, isEnabled: true, weekdays: ["", "", "", "", "", "", ""])
        
        viewController.title = "Add Alarm"
        let navController = UINavigationController(rootViewController: viewController)
        present(navController, animated:true, completion: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            Requests.deleteAlarm(id: alarms[indexPath.row].id, completion: { (response) in
                if response {
                    print("Delete alarm: ", self.alarms[indexPath.row].id, response)
                    AlarmsScheduler.removeNotification(hour: self.alarms[indexPath.row].hour, minute: self.alarms[indexPath.row].minute)
                    self.alarms.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    if self.alarms.count == 0 {
                        self.navigationItem.leftBarButtonItem = nil
                    }
                }
            })
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isEditing {
            
            let alarm = alarms[indexPath.row]
            
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditAlarmViewControllerID") as! AddEditAlarmViewController
            viewController.isEditingMode = true
            viewController.alarm = alarm
            viewController.title = "Edit Alarm"
            let navController = UINavigationController(rootViewController: viewController)
            present(navController, animated:true, completion: nil)
            
        }
    }
    
    
    
//    func getAlarmId(hour: Int, minute: Int) -> Int? {
//
//        for alarm in alarms {
//            if alarm.hour == hour && alarm.minute == minute {
//                return alarm.id
//            }
//        }
//        return nil
//    }
    
    
    
}

