//
//  CustomTextField.swift
//  TakeMyMoney
//
//  Created by Rohit Jangid on 24/11/20.
//

import UIKit

class CustomTextField: UITextField {
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        datePicker.preferredDatePickerStyle = .wheels
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    func endTextFieldEditing() {
        layer.borderWidth = 0
        layer.borderColor = nil
        text = ""
        endEditing(true)
    }
    
    func checkForEmptyTextField() -> Bool {
        if text != "" {
            layer.borderWidth = 0
            layer.borderColor = nil
            return true
        } else {
            layer.borderWidth = 1
            layer.borderColor = UIColor.red.cgColor
            return false
        }
    }
    
    func showError() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
    }
    
    func hideError() {
        layer.borderWidth = 0
        layer.borderColor = nil
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
