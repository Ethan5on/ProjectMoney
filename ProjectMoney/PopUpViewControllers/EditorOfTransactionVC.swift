//
//  EditorOfTransactionVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import UIKit

class EditorOfTransactionVC: UIViewController, indexPathPasser, UIGestureRecognizerDelegate {
    
    //MARK: - Upper Bar Buttons
    @IBOutlet weak var backArrowBtn: UIButton!
    @IBOutlet weak var circleBtn: UIButton!
    @IBOutlet weak var ExpIncSegument: UISegmentedControl!
    
    //MARK: - Date Picker
    @IBOutlet weak var dateAndTimePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var onToolbarDateBtn: UIButton!
    @IBOutlet weak var onToolbarTimeBtn: UIButton!
    
    //MARK: - Content Text Fields
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateAndTimeButton: UIButton!
    @IBOutlet weak var payeeTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    
    var keyboardDismissGesture : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    
    var indexPathFromTable: [Int] = [0, 0]
    
    var newTransactionUpdateDelegate : EventDataTransactionDelegate?
    
    var transactions: [TransactionEntity] = []
    
    var onEditorPopUpSegueIndex: Int = 0
    
    var dataFormatter: DataFormatter = DataFormatter()

    var ts: [TransactionEntity] = []
    
    //MARK: - View Did Load Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.keyboardDismissGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissGesture)
        
        
        datePickerView.isHidden = true
        
        ts = AccountVC.db.readTransaction()
        
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
            self.dateAndTimeButton.titleLabel?.text = "\(ts[indexPathFromTable[1]].date), \(ts[indexPathFromTable[1]].time)"
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
        let dateAndTime = dateAndTimeButton.titleLabel?.text ?? ""
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
            
            AccountVC.db.updateTransaction(id: ts[indexPathFromTable[1]].id,
                                           name: itemNameTextField.text ?? "",
                                           account_Id: 0,                       ///
                                           firstCategory_Id: 0,                 ///
                                           secondCategory_Id: 0,                ///
                                           amount: amount,
                                           date: String(dateAndTime.prefix(10)),
                                           time: String(dateAndTime.suffix(5)),
                                           payee: payeeTextField.text ?? "",
                                           memo: memoTextField.text ?? "")
            
            
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
    
    //MARK: - Date Picker
    @IBAction func onToolbarDateBtnClicked(_ sender: UIButton) {
        print("EditorOfTransactionVC - onToolbarDateBtnClicked() called")
        self.dateAndTimePicker.datePickerMode = .date
        
    }
    
    @IBAction func onToolbarTimeBtnClicked(_ sender: UIButton) {
        print("EditorOfTransactionVC - onToolbarTimeBtnClicked() called")

        dateAndTimePicker.datePickerMode = .time
    }
    
    @IBAction func onToolbarDoneBtnClicked(_ sender: UIButton) {
        print("EditorOfTransactionVC - onToolbarDoneBtnClicked() called")

        dateAndTimeButton.setTitle("\(dataFormatter.dateFormatter(inputValue: dateAndTimePicker.date)), \(dataFormatter.timeFormatter(inputValue: dateAndTimePicker.date))", for: .normal)
    }

    
    @IBAction func textBtn(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {self.datePickerView.isHidden = false})
        
    }
    
    
    
    
    func onCellEditBtnClicked(indexPathFromCell: [Int]) {
        print("EditorOfTransactionVC - onCellEditBtnClicked() called / indexPathFromCell = \(indexPathFromCell)")
        indexPathFromTable = indexPathFromCell
//        accountTextField.
//        accountTextField.insertText("123")
    }
    

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: accountTextField) == true){
            print("Touched accountTextField.")
            datePickerView.isHidden = true
            return false
        } else if (touch.view?.isDescendant(of: itemNameTextField) == true){
            print("Touched itemNameTextField.")
            datePickerView.isHidden = true
            return false
        } else if (touch.view?.isDescendant(of: amountTextField) == true){
            print("Touched amountTextField.")
            datePickerView.isHidden = true
            return false
        } else if (touch.view?.isDescendant(of: payeeTextField) == true){
            print("Touched payeeTextField.")
            datePickerView.isHidden = true
            return false
        } else if (touch.view?.isDescendant(of: memoTextField) == true){
            print("Touched memoTextField.")
            datePickerView.isHidden = true
            return false
        } else if (touch.view?.isDescendant(of: dateAndTimeButton) == true){
            print("Touched dateAndTimeButton.")
            view.endEditing(true)
            datePickerView.isHidden = false
            return true
        } else if (touch.view?.isDescendant(of: onToolbarDateBtn) == true){
            print("Touched onToolbarDateBtn.")
            datePickerView.isHidden = false
            return true
        } else if (touch.view?.isDescendant(of: onToolbarTimeBtn) == true){
            print("Touched onToolbarTimeBtn.")
            datePickerView.isHidden = false
            return true
        } else if (touch.view?.isDescendant(of: dateAndTimePicker) == true){
            print("Touched dateAndTimePicker.")
            datePickerView.isHidden = false
            return true
        } else {
            print("화면이 터치되었다.")
            datePickerView.isHidden = true
            view.endEditing(true)
            return true
        }
    }
    
}
