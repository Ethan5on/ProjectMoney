//
//  CreateAccountVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/02/04.
//

import Foundation
import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    var accountFromDB: [AccountEntity] = []
    let allAccountEntity: AccountEntity = AccountEntity(id: 0, name: "All accounts")
        
    var changedAccountDelegate: CreateAccountVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentViewHeightConstraint.constant = view.frame.height * 1.2
        titleLabel.layer.cornerRadius = 8.5
        titleLabel.layer.borderWidth = 1.85
        titleLabel.layer.borderColor = UIColor.systemGray5.cgColor
        
        accountFromDB = AccountVC.db.readAccount()
        
        accountFromDB.insert(allAccountEntity, at: 0)
        
        accountTableView.register(UITableViewCell.self, forCellReuseIdentifier: "accountTableViewCellId")
        
        accountTableView.dataSource = self
        accountTableView.delegate = self
        editableTextField.delegate = self
                
        print(currentAccount_Global)
    }
    
    @IBAction func backArrowBtnClicked(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    var timesPlusBtnClicked: Int = 0
    
    @IBAction func plusBtnClicked(_ sender: UIButton) {
        
        timesPlusBtnClicked += 1
        print("timesPlusBtnClicked : \(timesPlusBtnClicked)")
        
        switch timesPlusBtnClicked {
        case 1:
            UIView.animate(withDuration: 0.3, animations: {
                self.plusButton.transform = self.plusButton.transform.rotated(by: CGFloat(Double.pi / 4 * 3))
            })
           
            
            let emptyRowData: AccountEntity = AccountEntity(id: 0, name: "")
            accountFromDB.insert(emptyRowData, at: 0)
            accountTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)

            accountTableView.cellForRow(at: [0, 0])?.contentView.addSubview(editableTextField)
            editableTextField.frame = CGRect(x: 0, y: 0, width: Int(accountTableView.frame.width), height: 25)
            editableTextField.leadingAnchor.constraint(equalTo: accountTableView.cellForRow(at: [0, 0])!.leadingAnchor, constant: 55).isActive = true
            editableTextField.centerYAnchor.constraint(equalTo: accountTableView.cellForRow(at: [0, 0])!.centerYAnchor).isActive = true
            
            accountTableView.isEditing = true
            editableTextField.becomeFirstResponder()
            
        case 2:
            accountFromDB.removeFirst()
            accountTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            UIView.animate(withDuration: 0.3, animations: {
                self.plusButton.transform = self.plusButton.transform.rotated(by: CGFloat(Double.pi / 4 * 3))
                self.accountTableView.isEditing = false
            })
            timesPlusBtnClicked = 0
            
        default:
            print("default")
        }
    }
    
    lazy private var editableTextField: UITextField = {
    let textField = UITextField(frame: .zero)
            textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
        }()
}







extension CreateAccountVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        tableView.beginUpdates()
        tableView.endUpdates()
        if indexPath == [0, 0] {
            return .insert
        } else if accountTableView.cellForRow(at: indexPath)?.textLabel?.text == "All accounts" {
            return .none
        } else {
            return .delete
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .insert:
            
            if editableTextField.hasText == true {
                print("inserted row to table")
                timesPlusBtnClicked = 0
                
                accountFromDB[0].name = editableTextField.text!
                editableTextField.isHidden = true
                accountTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                
                AccountVC.db.insertAccount(name: editableTextField.text!)
                accountFromDB = AccountVC.db.readAccount()
                accountFromDB.insert(allAccountEntity, at: 0)

                
                UIView.animate(withDuration: 0.3, animations: {
                    self.plusButton.transform = self.plusButton.transform.rotated(by: CGFloat(Double.pi / 4 * 3))
                    self.accountTableView.isEditing = false
                })
            } else {
                let alert = UIAlertController(title: nil, message: "Name of account need to be filled.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.present(alert, animated: true)
            }
            
        case .delete:
            print("Deleted row from table")
            
            guard accountTableView.cellForRow(at: indexPath)?.textLabel?.text != "All accounts" else {
                return
            }
            let accountName = accountTableView.cellForRow(at: indexPath)?.textLabel?.text
            AccountVC.db.deleteAccountById(id: accountFromDB.filter{ $0.name == accountName }[0].id)
            accountFromDB = accountFromDB.filter{ $0.name != accountName}
            
            accountTableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
        default:
            print("Default")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let checkImage = UIImage(systemName: "checkmark.circle.fill")
        let checkImageView = UIImageView(image: checkImage)
        checkImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        tableView.cellForRow(at: indexPath)?.accessoryView = checkImageView

        var i: Int = 0
        for account in accountFromDB {
            if currentAccount_Global?.isEmpty == true {
                tableView.cellForRow(at: [0, 0])?.accessoryView = nil
            }else if account.name == currentAccount_Global {
                break
            }

            i += 1
        }
        tableView.cellForRow(at: [0, i])?.accessoryView = nil

        if let nameOfAccount = tableView.cellForRow(at: indexPath)?.textLabel?.text {
            changedAccountDelegate?.onCreateAccountVCChangedAccount(accountName: nameOfAccount)
        }
        dismiss(animated: true, completion: nil)
    }
    
}



extension CreateAccountVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountFromDB.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = accountTableView.dequeueReusableCell(withIdentifier: "accountTableViewCellId", for: indexPath)
        
        cell.textLabel?.text = accountFromDB[indexPath.row].name
        
        let checkImage = UIImage(systemName: "checkmark.circle.fill")
        let checkImageView = UIImageView(image: checkImage)
        checkImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        
        if cell.textLabel?.text == currentAccount_Global {
            
            cell.accessoryView = checkImageView
            
        } else if currentAccount_Global?.isEmpty == true {
            if cell.textLabel?.text == "All accounts" {
                
                cell.accessoryView = checkImageView

            }
        }
        
        return cell
    }
    
    
    
}



