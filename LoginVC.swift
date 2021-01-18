//
//  LoginVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/18.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var userIdStackView: UIStackView!
    
    @IBOutlet weak var userPasswordStackView: UIStackView!
    @IBOutlet weak var userPasswordLabel: UILabel!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var userIdStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var enterBtnBotConstraint: NSLayoutConstraint!
    
    var numberOfClickforEnterBtn: Int = 0
    
    static var db: UserListDatabaseManager = UserListDatabaseManager()
    
    var usersInformation: [UserEntity] = []
    
    //MARK: - View Did Load()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        LoginVC.db.dropUserListTable()
//        LoginVC.db.insertUser(user_ID: "ethan5on", user_Password: "jong1283", emailAdress: "ethan5on@kakao.com", name: "Ethan Son")
        usersInformation = LoginVC.db.readUser()
        
        self.userPasswordStackView.isHidden = true
        self.enterButton.isHidden = true
        self.headerLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardHideNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                 
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
                self.enterButton.isHidden = false
                self.enterBtnBotConstraint.constant = keyboardRectangle.height
                self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Enter Button Action
    @IBAction func enterButtonClicked(_ sender: UIButton) {
        
        numberOfClickforEnterBtn += 1
        switch numberOfClickforEnterBtn {
            //When Insert ID
        case 1:
            
            guard self.userIdTextField.text?.isEmpty == false else {
                self.numberOfClickforEnterBtn = 0
                
                let alert = UIAlertController(title: nil, message: "Insert Your ID", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                return
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.userIdStackViewTopConstraint.constant += self.userIdStackView.frame.height + 30
                self.userIdLabel.text = "ID"
            
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                                self.userPasswordStackView.isHidden = false
                                                self.signinButton.isHidden = true
                                                })
                self.view.layoutIfNeeded()
            })
            
            userPasswordTextField.becomeFirstResponder()
           
            //When Insert Password
        case 2:
            
            guard self.userPasswordTextField.text?.isEmpty == false else {
                self.numberOfClickforEnterBtn = 1
                
                let alert = UIAlertController(title: nil, message: "Insert Your Password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                return
            }
            
            // code for Checking Id & Passward
            for user in usersInformation {
                
                guard self.userIdTextField.text == user.user_ID, self.userPasswordTextField.text == user.user_Password else {
                    self.numberOfClickforEnterBtn = 1

                    let alert = UIAlertController(title: nil, message: "ID or Password is incorrect", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                    break
                }
                
            }
            print("Successfully Loged In")
            userPasswordTextField.resignFirstResponder()
            enterButton.isHidden = true
            userPasswordLabel.text = "Password"
            
            //Go to AccountVC
            let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
            let uvcs = storyboards.instantiateViewController(identifier: "AccountVCId") as! AccountVC
            uvcs.modalPresentationStyle = .fullScreen
            self.present(uvcs, animated: false, completion: nil)
        
        default :
            self.signinButton.isHidden = false
            break
            
        }
        
        print("LoginVC - numberOfClickforEnterBtn = \(numberOfClickforEnterBtn)")
    }
    
    @IBAction func signinButtonClicked(_ sender: UIButton) {
        print("LoginVC - signinButtonClicked() called")
        
    }
    
}