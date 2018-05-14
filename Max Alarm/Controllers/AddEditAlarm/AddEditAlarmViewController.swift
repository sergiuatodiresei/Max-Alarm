//
//  AddEditAlarmViewController.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import UIKit
import CoreLocation
import Solar

class AddEditAlarmViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, NewDays, NewLabel, NewSound {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var darkModeBtn: UIBarButtonItem!
    
    @IBOutlet weak var sunriseButton: UIButton!
    
    @IBOutlet weak var sunsetButton: UIButton!
    
    var sunriseButtonPressed: Bool?
    
    let locManager = CLLocationManager()
    
    var alarm: Alarm!
    
    var sound = "Apple"
    var isEditingMode = false
    var isDarkMode = false
    
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        locManager.delegate = self
        
        if isEditingMode {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            if let date = dateFormatter.date(from: "\(alarm.hour):\(alarm.minute)") {
                datePicker.date = date
            }
        }
        
        if userDefaults.bool(forKey: "isDarkMode") {
            darkModeEnabled()
        } else {
            darkModeDisabled()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled), name: .darkModeDisabled, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: datePicker.date)
        alarm.hour = comp.hour!
        alarm.minute = comp.minute!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isEditingMode {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {
            
            let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "detailsAlarmCell")
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Repeat"
                cell.detailTextLabel?.text = alarm.repeatTextAddEditAlarm
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Label"
                cell.detailTextLabel?.text = alarm.label
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Sound"
                cell.detailTextLabel?.text = sound
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Snooze"
                let snoozeSwitch = UISwitch()
                snoozeSwitch.addTarget(self, action: #selector(didPressSnoozeSwitch), for: .valueChanged)
                snoozeSwitch.setOn(true, animated: false)
                cell.accessoryView = snoozeSwitch
                cell.selectionStyle = .none
            }
            
            
            if isDarkMode {
                
                cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
                cell.textLabel?.textColor = .white
                cell.detailTextLabel?.textColor = .white
            } else {
                
                cell.backgroundColor = .clear
                cell.textLabel?.textColor = .black
                cell.detailTextLabel?.textColor = .black
                
            }
            
            return cell
            
        } else {
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "detailsAlarmCell")
            cell.textLabel?.text = "Delete Alarm"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
            
            if isDarkMode {
                cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            } else {
                cell.backgroundColor = .clear
            }
            
            return cell
        }
    }
    
    @objc func didPressSnoozeSwitch(){
        //
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.5
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let line =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.5))
            line.backgroundColor = tableView.separatorColor
            
            return line
        }
        
        let headerView =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        
        let line =  UIView(frame: CGRect(x: 0, y: 29.5, width: self.view.bounds.width, height: 0.5))
        line.backgroundColor = tableView.separatorColor
        headerView.addSubview(line)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let line =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.5))
        line.backgroundColor = tableView.separatorColor
        
        return line
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                let viewController = RepeatAlarmTableViewController()
                viewController.weekdays = alarm.weekdays
                viewController.isDarkMode = isDarkMode
                viewController.delegate = self
                navigationController?.pushViewController(viewController, animated: true)
            } else if indexPath.row == 1 {
                
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LabelViewControllerID") as! LabelViewController
                viewController.label = alarm.label
                viewController.isDarkMode = isDarkMode
                viewController.delegate = self
                navigationController?.pushViewController(viewController, animated: true)
            } else if indexPath.row == 2 {
                let viewController = SoundTableViewController()
                viewController.sound = sound
                viewController.isDarkMode = isDarkMode
                viewController.delegate = self
                navigationController?.pushViewController(viewController, animated: true)
            }
            
        } else {
            deleteAlarm()
        }
        
        let cell = tableView.cellForRow(at: indexPath)!
        cell.setSelected(false, animated: true)
        
    }
    
    func didChangeDays(_ weekdays: [String]) {
        if alarm.weekdays != weekdays {
            alarm.weekdays = weekdays
            tableView.reloadData()
        }
    }
    
    func didChangeLabel(_ text: String?) {
        
        guard let newLabel = text, !newLabel.isEmpty, newLabel != alarm.label else {return}
        alarm.label = newLabel
        tableView.reloadData()
    }
    
    func didChangeSound(_ sound: String) {
        if self.sound != sound {
            self.sound = sound
            tableView.reloadData()
        }
    }
    
    func deleteAlarm(){
        
        Requests.deleteAlarm(id: alarm.id) { (response) in
            if response {
                print("Delete alarm ", self.alarm.id, response)
                AlarmsScheduler.removeNotification(hour: self.alarm.hour, minute: self.alarm.minute)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    @IBAction func didPressCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didPressSaveButton(_ sender: UIBarButtonItem) {
        print("Save")
        print("Hour: ", alarm.hour)
        print("Minute: ", alarm.minute)
        print("Label:", alarm.label)
        
        
        if isEditingMode {

            Requests.updateAlarm(id: alarm.id, label: alarm.label, hour: alarm.hour, minute: alarm.minute, enabled: alarm.isEnabled, completion: { (alarm) in
                
                if alarm != nil {
                    print("Update alarm: ", alarm!.id)
                    
                    AlarmsScheduler.createNotification(hour: self.alarm.hour, minute: self.alarm.minute, sound: self.sound)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            Requests.postAlarm(label: alarm.label, hour: alarm.hour, minute: alarm.minute, completion: { (alarm) in
                
                if alarm != nil {
                    
                    print("New alarm: ", alarm!.id)
                    
                    AlarmsScheduler.createNotification(hour: self.alarm.hour, minute: self.alarm.minute, sound: self.sound)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
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
        
        tableView.backgroundColor = .black
        view.backgroundColor = .black
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.backgroundColor = .black
        
        sunriseButton.tintColor = .orange
        sunsetButton.tintColor = .orange
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
        view.backgroundColor = .white
        
        datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        datePicker.backgroundColor = .white
        
        sunriseButton.tintColor =  .red
        sunsetButton.tintColor = .red
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            didPressSolarButton()
        }
    }
    
    @IBAction func didPressSunriseButton(_ sender: UIButton) {
        sunriseButtonPressed = true
        didPressSolarButton()
    }
    
    @IBAction func didPressSunsetButton(_ sender: UIButton) {
        sunriseButtonPressed = false
        didPressSolarButton()
    }
    
    func didPressSolarButton() {
        
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
            
            setDatePicker(with: locManager.location?.coordinate)
            
        }
    }
    
    func setDatePicker(with coordinate: CLLocationCoordinate2D?) {
        
        guard let onSunrise = sunriseButtonPressed else {return}
        
        guard let coord = coordinate else {return}
        
        let solar = Solar(coordinate: coord)
        
        guard let sunrise =  solar?.sunrise, let sunset = solar?.sunset else {return}
        
        if onSunrise {
            datePicker.date = sunrise
        } else {
            datePicker.date = sunset
        }
        
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: datePicker.date)
        alarm.hour = comp.hour!
        alarm.minute = comp.minute!
    }
    
    
    
}
