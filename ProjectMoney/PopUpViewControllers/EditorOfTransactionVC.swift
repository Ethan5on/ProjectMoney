//
//  EditorOfTransactionVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import UIKit

class EditorOfTransactionVC: UIViewController, indexPathPasser {
    
    //MARK: - Upper Bar Buttons
    @IBOutlet weak var backArrowBtn: UIButton!
    @IBOutlet weak var circleBtn: UIButton!
    @IBOutlet weak var ExpIncSegument: UISegmentedControl!
    
    //MARK: - Content Text Fields
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTimeTextField: UITextField!
    @IBOutlet weak var payeeTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    
    
    var indexPathFromTable: [Int] = [0, 0]
    
    var newTransactionUpdateDelegate : EventDataTransactionDelegate?
    
    var transactions: [TransactionEntity] = []
    
    var onEditorPopUpSegueIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        
        let ts: [TransactionEntity] = AccountVC.db.readTransaction()
        if indexPathFromTable != [0, 0] {                               //Updating
            if ts[indexPathFromTable[1]].amount < 0 {
                ExpIncSegument.selectedSegmentIndex = 0
            }else if ts[indexPathFromTable[1]].amount > 0 {
                ExpIncSegument.selectedSegmentIndex = 1
            }
            self.accountTextField.text = String(ts[indexPathFromTable[1]].account_Id)
            self.categoryTextField.text = "\(ts[indexPathFromTable[1]].firstCategory_Id) > \(ts[indexPathFromTable[1]].secondCategory_Id)"
            self.itemNameTextField.text = ts[indexPathFromTable[1]].name
            self.amountTextField.text = String(ts[indexPathFromTable[1]].amount)
            self.dateTimeTextField.text = "\(ts[indexPathFromTable[1]].date), \(ts[indexPathFromTable[1]].time)"
            self.payeeTextField.text = ts[indexPathFromTable[1]].payee
            self.memoTextField.text = ts[indexPathFromTable[1]].memo
        }else {                                                         //Inserting
            ExpIncSegument?.selectedSegmentIndex = onEditorPopUpSegueIndex
        }
    }
    
    //MARK: - IBAction Upper Bar Buttons
    @IBAction func backArrowBtnClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func circleBtnClicked(_ sender: UIButton) {
        let dateAndTime = dateTimeTextField.text ?? ""
        var amount = Int(amountTextField.text ?? "")!
        
        switch ExpIncSegument.selectedSegmentIndex {
        case 0:
            amount *= -1
        case 1:
            amount *= 1
        default:
            return
        }
        
        if indexPathFromTable != [0, 0] {                               //Updating
            
            
        } else {                                                        //Inserting
            AccountVC.db.insertTransaction(name: itemNameTextField.text ?? "",
                                           account_Id: 0,                       ///
                                           firstCategory_Id: 0,                 ///
                                           secondCategory_Id: 0,                ///
                                           amount: amount,
                                           date: String(dateAndTime.prefix(10)),
                                           time: String(dateAndTime.suffix(5)),
                                           payee: payeeTextField.text ?? "",
                                           memo: memoTextField.text ?? "")
        }
        
        newTransactionUpdateDelegate?.onEditorVCCircleBtnClicked()
        dismiss(animated: true, completion: nil)
    }
    
    
    func onCellEditBtnClicked(indexPathFromCell: [Int]) {
        print("EditorOfTransactionVC - onCellEditBtnClicked() called / indexPathFromCell = \(indexPathFromCell)")
        indexPathFromTable = indexPathFromCell
//        accountTextField.
//        accountTextField.insertText("123")
    }
    
    
    
}
