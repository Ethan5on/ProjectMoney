//
//  PlusBtnPopUpVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import UIKit

class PlusBtnPopUpVC: UIViewController {
    
    //MARK: - Button Outlets
    @IBOutlet weak var expenseBtn: UIButton!
    @IBOutlet weak var incomeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    var toEditorDelegate : EventDataTransactionDelegate?
    
    //MARK: - ViewDIdLoad Function
    override func viewDidLoad() {
       super.viewDidLoad()
        
        expenseBtn.layer.cornerRadius = 10
        incomeBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
    }
    
    
    //MARK: - IBAction Functions
    @IBAction func expenseBtnClicked(_ sender: UIButton) {
        
        print("PlusBtnPopUpVC - expenseBtnClicked() called")
        toEditorDelegate?.onPlusPopUpVCBtnClicked(segueIndex: 0)
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func incomeBtnClicked(_ sender: UIButton) {
        
        print("PlusBtnPopUpVC - incomeBtnClicked() called")
        toEditorDelegate?.onPlusPopUpVCBtnClicked(segueIndex: 1)
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        
        print("PlusBtnPopUpVC - cancelBtnClicked() called")
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


