//
//  Sign_InVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/19.
//

import Foundation
import UIKit

class Sign_InVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var enterBtnBotConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userIdStackVIew: UIStackView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userIdTextField: UITextField!
    
    @IBOutlet weak var userPasswordStackView: UIStackView!
    @IBOutlet weak var userPasswordLabel: UILabel!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordStackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userNameStackView: UIStackView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameStackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userEmailStackView: UIStackView!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userEmailStackViewConstraint: NSLayoutConstraint!
    
    var numberOfClickforEnterBtn: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint(item: headerLabel!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1.0, constant: 50.0).isActive = true
        NSLayoutConstraint(item: headerLabel!, attribute: .bottom, relatedBy: .equal, toItem: enterButton, attribute: .topMargin, multiplier: 1.0, constant: -60.0).isActive = true
        self.headerLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardHideNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)


        userPasswordStackView.isHidden = true
        userNameStackView.isHidden = true
        userEmailStackView.isHidden = true

      
    }
    
    //MARK: - Keyborad Notification handles
    @objc
    private func handle(keyboardHideNotification notification: Notification) {
        // 1
        print("Keyboard hide notification")
        
        // 2
        if notification.userInfo != nil {
                self.enterBtnBotConstraint.constant = 0
                self.view.layoutIfNeeded()
        }
    }
    
    
    @objc
    private func handle(keyboardShowNotification notification: Notification) {
        // 1
        print("Keyboard show notification")
        
        // 2
        if let userInfo = notification.userInfo,
            // 3
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.enterBtnBotConstraint.constant = keyboardRectangle.height
                self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Enter button
    @IBAction func enterButtonClicked(_ sender: UIButton) {
        
        numberOfClickforEnterBtn += 1
        print( "numberOfClickforEnterBtn = \(numberOfClickforEnterBtn)")
        
        switch numberOfClickforEnterBtn {
        
        case 1:
            checkingIsEmpty(timesForEnter: 1, textField: userIdTextField, alertMessage: "Insert Your ID", nextStackView: userPasswordStackView, nextSVConstraint: userPasswordStackViewConstraint)
            userPasswordTextField.becomeFirstResponder()
            
        case 2:
            
            checkingIsEmpty(timesForEnter: 2, textField: userPasswordTextField, alertMessage: "Insert Your Password", nextStackView: userNameStackView, nextSVConstraint: userNameStackViewConstraint)
            userNameTextField.becomeFirstResponder()

            print(2)
            
        case 3:
            checkingIsEmpty(timesForEnter: 3, textField: userNameTextField, alertMessage: "Insert Your Name", nextStackView: userEmailStackView, nextSVConstraint: userEmailStackViewConstraint)
            userEmailTextField.becomeFirstResponder()
            print(3)
            
        case 4:
            checkingIsEmpty(timesForEnter: 4, textField: userEmailTextField, alertMessage: "Insert Your Email", nextStackView: nil, nextSVConstraint: nil)
            print(4)
            
        case 5:
            
            _ = navigationController?.popToRootViewController(animated: true)
            print(5)
            
        default:
            print("break")
            return
        }
        

    }
    
    fileprivate func checkingIsEmpty(timesForEnter: Int, textField: UITextField, alertMessage: String, nextStackView: UIStackView?, nextSVConstraint: NSLayoutConstraint?) {
        
        guard textField.text?.isEmpty == false else {
            self.numberOfClickforEnterBtn = timesForEnter - 1
            let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        guard nextStackView != nil, nextSVConstraint != nil else {
            
            if userIdTextField.text == "" || userPasswordTextField.text == "" || userNameTextField.text == "" || userEmailTextField.text == "" {
                let alert = UIAlertController(title: nil, message: "All boxes need to be filled", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                LoginVC.db.insertUser(user_ID: userIdTextField.text!, user_Password: userPasswordTextField.text!, name: userNameTextField.text!, emailAdress: userEmailTextField.text!)
            }

            return
            
        }
        
            UIView.animate(withDuration: 0.35, animations: {
                nextSVConstraint?.constant = self.userIdStackVIew.frame.height + 10
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                    nextStackView?.isHidden = false
                                                })
                self.view.layoutIfNeeded()
            })

    }
    
    @IBOutlet weak var naviBarBackButton: UINavigationItem!
    
    
    
    
}
