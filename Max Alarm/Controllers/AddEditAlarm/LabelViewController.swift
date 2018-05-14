//
//  LabelViewController.swift
//  Max Alarm
//
//  Created by Sergiu Atodiresei on 13.05.2018.
//  Copyright © 2018 SergiuApps. All rights reserved.
//

import UIKit

protocol NewLabel {
    
    func didChangeLabel(_ text: String?)
}

class LabelViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate: NewLabel?
    
    var label: String!
    var isDarkMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Label"
        
        textField.text = label
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.becomeFirstResponder()
        textField.delegate = self
        
        scrollView.alwaysBounceVertical = true
        
        if isDarkMode {
            contentView.backgroundColor = .black
            view.backgroundColor = .black
            textField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            textField.textColor = .white
            textField.tintColor = .orange
            textField.keyboardAppearance = .dark
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        delegate?.didChangeLabel(textField.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        navigationController?.popViewController(animated: true)
        
        return false
    }
    
}
