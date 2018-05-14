//
//  RepeatAlarmTableViewController.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import UIKit

protocol NewDays {
    func didChangeDays(_ weekdays: [String])
}

class RepeatAlarmTableViewController: UITableViewController {
    
    var weekdays: [String]!
    
    var delegate: NewDays?
    
    var isDarkMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Repeat"
        
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        tableView.tableFooterView = UIView()
        
        if isDarkMode {
            tableView.backgroundColor = .black
        } else {
            tableView.backgroundColor = .white
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        delegate?.didChangeDays(weekdays)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "dayCell")
        cell.textLabel?.text = "Every " + getDay(indexPath.row)
        
        if weekdays[indexPath.row] != "" {
            cell.accessoryType = .checkmark
        }
        
        if isDarkMode {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            cell.textLabel?.textColor = .white
            cell.tintColor = .orange
        } else {
            
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = .black
            cell.tintColor = view.tintColor
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        
        if weekdays[indexPath.row] == "" {
            weekdays[indexPath.row] = String(getDay(indexPath.row))
            cell.accessoryType = .checkmark
            cell.setSelected(false, animated: true)
        } else {
            weekdays[indexPath.row] = ""
            cell.accessoryType = .none
            cell.setSelected(false, animated: true)
        }
    }
    
    func getDay(_ day: Int) -> String {
        switch day {
        case 0:
            return "Monday"
        case 1:
            return "Tuesday"
        case 2:
            return "Wednesday"
        case 3:
            return "Thursday"
        case 4:
            return "Friday"
        case 5:
            return "Saturday"
        case 6:
            return "Sunday"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        
        let line =  UIView(frame: CGRect(x: 0, y: 29.5, width: self.view.bounds.width, height: 0.5))
        line.backgroundColor = tableView.separatorColor
        headerView.addSubview(line)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let line =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.5))
        line.backgroundColor = tableView.separatorColor
        
        return line
    }
    
}
