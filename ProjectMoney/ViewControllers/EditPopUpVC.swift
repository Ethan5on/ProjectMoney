//
//  EditPopUpVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2020/12/17.
//

import UIKit

class EditPopUpVC: UIViewController {
    
    @IBOutlet weak var expenseBtn: UIButton!
    @IBOutlet weak var incomeBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    var myPopUpDelegate : BtnClickDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("EditPopUpVC - viewDidLoad() called")
        
        expenseBtn.layer.cornerRadius = 10
        incomeBtn.layer.cornerRadius = 10
        editBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        print("EditPopUpVC - cancelBtnClicked() called")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func expenseBtnClicked(_ sender: UIButton) {
        print("EditPopUpVC - expenseBtnClicked() called")
        
        myPopUpDelegate?.expenseBtnClicked()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func incomeBtnClicked(_ sender: UIButton) {
        print("EditPopUpVC - incomeBtnClicked() called")

        self.dismiss(animated: true, completion: nil)
        
//        myPopUpDelegate?.incomeBtnClicked()
        
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton) {
        print("EditPopUpVC - editBtnClicked() called")
        
        self.dismiss(animated: true, completion: nil)
        
//        myPopUpDelegate?.editBtnClicked()
        
    }
    
    
    
    
    
}
