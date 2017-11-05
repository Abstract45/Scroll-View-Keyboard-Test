//
//  ViewController.swift
//  Scroll View KeyBoard Test
//
//  Created by William Friend on 11/4/17.
//  Copyright © 2017 William Friend. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var textField01: UITextField!
    @IBOutlet weak var textField02: UITextField!
    @IBOutlet weak var textField03: UITextField!
    @IBOutlet weak var textField04: UITextField!
    @IBOutlet weak var textField05: UITextField!
    
    @IBOutlet weak var testScrollView01: UIScrollView!
    
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.textField01.delegate = self
        self.textField02.delegate = self
        self.textField03.delegate = self
        self.textField04.delegate = self
        self.textField05.delegate = self
        
        self.testScrollView01.delegate = self
        
        self.hideKeyboard()
        
        registerTextFieldKeyboardNotifications()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //registerTextFieldKeyboardNotifications()
    }
    
    
    func registerTextFieldKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.textFieldKeyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.textFieldKeyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        print("Notification Sent")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: KEYBOARD SHOW/HIDE
    
    @objc func textFieldKeyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        print("Keyboard shown")
        
        self.testScrollView01.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = ((info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size)
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 50, 0.0)
        
        self.testScrollView01.contentInset = contentInsets
        self.testScrollView01.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.testScrollView01.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func textFieldKeyboardWillBeHidden(notification: NSNotification){
        
        print("Keyboard hidden")
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.testScrollView01.contentInset = contentInsets
        self.testScrollView01.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.testScrollView01.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeTextField = nil
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}

//MARK: EXTENSIONS


extension UIViewController
{
    func hideKeyboard()
        // Used to hide keyboard when clicked outside text field
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
