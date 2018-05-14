//
//  SoundTableViewController.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import UIKit

protocol NewSound {
    func didChangeSound(_ sound: String)
}

class SoundTableViewController: UITableViewController {
    
    var sound: String!
    var isDarkMode: Bool!
    
    var delegate: NewSound?
    
    let sounds = ["Apple (Default)", "Pineapple", "Watermelon",  "Bulletin", "By The Seaside", "Chimes", "Circuit",
                  "Constellation", "Cosmic", "Crystals", "Hillside", "Illuminate", "Night Owl", "Opening",
                  "Playtime", "Presto", "Radiate", "Reflection", "Ripples", "Sencha", "Signal", "Silk",
                  "Slow Rise", "Stargaze", "Summit", "Twinkle", "Uplift", "Waves", "Classic"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sound"
        
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
        
        delegate?.didChangeSound(sound)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return sounds.count
        }
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "soundCell")
        
        if indexPath.section == 0 {
            cell.textLabel?.text = sounds[indexPath.row]
            
            if indexPath.row == 0 && sound == "Radar" {
                cell.accessoryType = .checkmark
            } else if sounds[indexPath.row] == sound {
                cell.accessoryType = .checkmark
            }
            
        } else {
            cell.textLabel?.text = "None"
            if sound == "None" {
                cell.accessoryType = .checkmark
            }
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
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                sound = "Radar"
            } else {
                sound = sounds[indexPath.row]
            }
        } else {
            sound = "None"
        }
        
        cell.setSelected(false, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == 1 {
            return 30
        }

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

        if section == 0 {

            let line =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.5))
            line.backgroundColor = tableView.separatorColor

            return line
        }

        let footerView =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        let line =  UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.5))
        line.backgroundColor = tableView.separatorColor
        footerView.addSubview(line)

        return footerView
    }
    
    
}
