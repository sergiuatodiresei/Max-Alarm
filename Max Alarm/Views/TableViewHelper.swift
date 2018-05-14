//
//  TableViewHelper.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import UIKit

class TableViewHelper {
    
    class func EmptyMessage(message:String, viewController:UITableViewController) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 19)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel;
        viewController.tableView.separatorStyle = .none
        
    }
    
    class func  WithoutMessage(viewController:UITableViewController) {
        
        viewController.tableView.backgroundView = UIView();
        viewController.tableView.separatorStyle = .singleLine
    }
}
