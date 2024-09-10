//
//  ViewController.swift
//  TestProjectSep10
//
//  Created by Rafsan Nazmul on 9/10/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var messageWriteView: UIView!
    
    @IBOutlet weak var messageWriteViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageWriteViewBottomConstraint: NSLayoutConstraint!
    
    
    // MARK: View Loading Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notification Center Observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: IBActions
    
    // MARK: Actions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if messageWriteViewBottomConstraint.constant == 0 {
                messageWriteViewBottomConstraint.constant = keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if messageWriteViewBottomConstraint.constant != 0 {
            messageWriteViewBottomConstraint.constant = 0
        }
    }
    
    
}

