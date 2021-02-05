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
    
    @IBOutlet weak var remeberSwitchStackVeiw: UIStackView!
    @IBOutlet weak var rememberSwitch: UISwitch!
    
    @IBOutlet weak var userIdStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var enterBtnBotConstraint: NSLayoutConstraint!
    
    var numberOfClickforEnterBtn: Int = 0
    
    static var db: UserListDatabaseManager = UserListDatabaseManager()
    
    var usersInformation: [UserEntity] = []
    
    static var logedInId: String? = nil
    
    //MARK: - View Did Load()
    override func viewDidLoad() {
        super.viewDidLoad()
//        LoginVC.db.dropUserListTable()
//        LoginVC.db.insertUser(user_ID: "ethan5on", user_Password: "jong1283", emailAdress: "ethan5on@kakao.com", name: "Ethan Son")
        usersInformation = LoginVC.db.readUser()
        LoginVC.logedInId = LoginVC.db.readRememberUser()
        
        if LoginVC.logedInId?.count != 0 {
            print(" \(String(describing: LoginVC.logedInId))")
            
            let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
            let uvcs = storyboards.instantiateViewController(identifier: "AccountVCId") as! AccountVC
            uvcs.modalPresentationStyle = .fullScreen
            self.present(uvcs, animated: false, completion: nil)
        }
        
        
        NSLayoutConstraint(item: headerLabel!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1.0, constant: 50.0).isActive = true
        NSLayoutConstraint(item: headerLabel!, attribute: .bottom, relatedBy: .equal, toItem: enterButton, attribute: .topMargin, multiplier: 1.0, constant: -60.0).isActive = true
        self.headerLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

        
        self.userPasswordStackView.isHidden = true
        self.remeberSwitchStackVeiw.isHidden = true
        

        print(headerLabel.constraints)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardHideNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear() called")
        super.viewDidAppear(animated)
        usersInformation = LoginVC.db.readUser()
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
    
    //MARK: - Delegate
    func onSigninVCEnter() {
        print("Delegate : LoginVC - onSigninVCEnter() called")
        usersInformation = LoginVC.db.readUser()
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
                                                self.remeberSwitchStackVeiw.isHidden = false
                                                })
                self.view.layoutIfNeeded()
            })
            
            self.userPasswordTextField.becomeFirstResponder()
           
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
            userloop: for user in usersInformation {
                
                if self.userIdTextField.text! == user.user_ID && self.userPasswordTextField.text! == user.user_Password {
                    print("Successfully Loged In")
                    
                    if rememberSwitch.isOn {
                        print("Remember this user")
                        LoginVC.logedInId = user.user_ID
                        LoginVC.db.insertRememberUser(user_ID: self.userIdTextField.text!)
                    }
                    
                    self.userPasswordTextField.resignFirstResponder()
                    self.userPasswordLabel.text = "Password"

                    
                    let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
                    let uvcs = storyboards.instantiateViewController(identifier: "AccountVCId") as! AccountVC
                    uvcs.modalPresentationStyle = .fullScreen
                    LoginVC.logedInId = user.user_ID
                    self.present(uvcs, animated: false, completion: nil)
                    
                    return
                }
                
            }
            
            
            self.numberOfClickforEnterBtn = 1

            let alert = UIAlertController(title: nil, message: "ID or Password is incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)

            

        
        default :
            print(11111111)
            return
            
        }
        
        print("LoginVC - numberOfClickforEnterBtn = \(numberOfClickforEnterBtn)")
    }
    
    
    @IBAction func signinButtonClicked(_ sender: UIButton) {
        print("LoginVC - signinButtonClicked() called")
        
        performSegue(withIdentifier: "signinSegue", sender: self)
    }
    

}
