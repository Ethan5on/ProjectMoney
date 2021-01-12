//
//  EditorOfTransactionVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import UIKit
import Foundation

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

    @IBOutlet weak var accountButton: UIButton!

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateAndTimeButton: UIButton!
    @IBOutlet weak var payeeTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    
    @IBOutlet weak var textBtn: UIButton!
    
    var keyboardDismissGesture : UIGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    var editingTransactionIdFromTable: Int?
    
    var newTransactionUpdateDelegate : EventDataTransactionDelegate?
        
    var onEditorPopUpSegueIndex: Int = 0
    
    var dataFormatter: DataFormatter = DataFormatter()

    var transactions: [TransactionEntity] = []
    var accounts: [AccountEntity] = []
    var catFirst: [FirstCategoryEntity] = []
    var catSecond: [SecondCategoryEntity] = []
    
    //MARK: - View Did Load Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountButton.setTitle("Account", for: .normal)
        categoryButton.setTitle("Category", for: .normal)
        
        
        self.keyboardDismissGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissGesture)
        
        datePickerView.isHidden = true
        
        transactions = AccountVC.db.readTransaction()
        accounts = AccountVC.db.readAccount()
        catFirst = AccountVC.db.readFirstCategory()
        catSecond = AccountVC.db.readSecondCategoy()
 
        
        
        accountMenus()
        categoryMenus()
        drawingInformationOfTransactionOrNot()
        
      

    }
    //MARK: - Drawing infomation of transaction
    @objc private func drawingInformationOfTransactionOrNot() {
        print("EditorOfTransactionVC - drawingInformationOfTransactionOrNot() called")

        
        if editingTransactionIdFromTable != nil {                               //When Updating
            
            let account_Id = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].account_Id
            let account_name = accounts.filter{ $0.id == account_Id }[0].name
            let firstCat_Id = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].firstCategory_Id
            let firstCat_name = catFirst.filter{ $0.id == firstCat_Id }[0].name
            let secondCat_Id = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].secondCategory_Id
            
            var secondCat_name: String = ""
            if secondCat_Id != 0 {
                secondCat_name = " > \(catSecond.filter{ $0.id == secondCat_Id }[0].name)"
            }

            let name = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].name
            let amount = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].amount
            let date = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].date
            let time = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].time
            let payee = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].payee
            let memo = transactions.filter{ $0.id == editingTransactionIdFromTable }[0].memo
            
            
            if amount < 0 {
                ExpIncSegument.selectedSegmentIndex = 0
            }else if amount > 0 {
                ExpIncSegument.selectedSegmentIndex = 1
            }
            self.accountButton.setTitle(String(account_name), for: .normal)
            self.categoryButton.setTitle("\(firstCat_name)\(secondCat_name)", for: .normal)
            self.itemNameTextField.text = name
            self.amountTextField.text = String(amount)
            self.dateAndTimeButton.setTitle("\(date), \(time)", for: .normal)
            self.payeeTextField.text = payee
            self.memoTextField.text = memo
            
        }else {                                                         //When Inserting
            
            ExpIncSegument?.selectedSegmentIndex = onEditorPopUpSegueIndex
            dateAndTimeButton.setTitle("\(self.dataFormatter.dateFormatter(inputValue: Date())), \(self.dataFormatter.timeFormatter(inputValue: Date()))", for: .normal)
            
        }
        
    }
    
    //MARK: - Menus for Account & Categories
    @objc private func accountMenus() {
        print("EditorOfTransactionVC - accountMenus() called")

    
        accountButton.showsMenuAsPrimaryAction = true
        var accountFromDB: [String] = []
        for i in accounts {
           accountFromDB.append(i.name)
        }

        func uiElementArray(name: [String]) -> [UIMenuElement] {
            
            var result: [UIMenuElement] = []
            for i in name {
                result.append(UIAction(title: i, handler: { _ in self.accountButton.setTitle(i, for: .normal)}))
            }
            result.append(UIAction(title: "Add", attributes: .destructive, handler: { _ in self.addAccount() }))
            return result
        }
        
        accountButton.menu = UIMenu(title: "Account",
                                    image: nil,
                                    identifier: nil,
                                    options: .destructive,
                                    children: uiElementArray(name: accountFromDB))
    }
    
    
    @objc private func categoryMenus() {
        
        categoryButton.showsMenuAsPrimaryAction = true
        var firstCategoryFromDB: [String] = []
        for i in catFirst {
            firstCategoryFromDB.append(i.name)
        }

        func uiElementArray(name: [String]) -> [UIMenuElement]{
            var result: [UIMenuElement] = []
            
            for i in name {
                
                let subs = AccountVC.db.loadSubcategory(name: i)
                
                if subs.count != 0  {
                    var catSecond: [UIMenuElement] = []
                        for j in subs {
                            catSecond.append(UIAction(title: j, handler: { _ in self.categoryButton.setTitle("\(i) > \(j)", for: .normal)}))
                        }

                    result.append(UIMenu(title: i, children: catSecond))
                } else {
                    result.append(UIAction(title: i, handler: {_ in self.categoryButton.setTitle(i, for: .normal)}))
                }
            }
            result.append(UIAction(title: "Add", attributes: .destructive, handler: { _ in self.addCategory() }))
            return result
        }

        
        categoryButton.menu = UIMenu(title: "Category",
                                     image: nil,
                                     identifier: nil,
                                     options: .displayInline,
                                     children: uiElementArray(name: firstCategoryFromDB))
    }
    
    
    @objc func addAccount() {
        print("addAcount() called")
    }
    
    @objc func addCategory() {
        print("addCategory() called")
    }
    
    
    //MARK: - IBAction Upper Bar Buttons
    @IBAction func backArrowBtnClicked(_ sender: UIButton) {
        print("EditorOfTransactionVC - backArrowBtnClicked() called")
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func circleBtnClicked(_ sender: UIButton) {
        print("EditorOfTransactionVC - circleBtnClicked() called")

        //Alert Pop up
        guard accountButton.titleLabel?.text != "Account" && categoryButton.titleLabel?.text != "Category" && itemNameTextField.text != "" && amountTextField.text != "" else {
            print("Some of values need to be filled")
            let alert = UIAlertController(title: "Alert", message: "Some of infomation need to be filled.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true)
            return
        }
        
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
        
        let separator = " > "
        
        
        
        var secondCatInt: Int = 0
        if categoryButton.titleLabel?.text?.components(separatedBy: separator).count == 2 {
            secondCatInt = AccountVC.db.getSecondCatFromTitle(name: categoryButton.titleLabel?.text?.components(separatedBy: separator)[1] ?? "")
        }
        
        if editingTransactionIdFromTable != nil {                               //Updating
            
            AccountVC.db.updateTransaction(id: editingTransactionIdFromTable!,
                                           name: itemNameTextField.text ?? "",
                                           account_Id: AccountVC.db.getAccountIdFromTitle(name: accountButton.titleLabel?.text ?? ""),
                                           firstCategory_Id: AccountVC.db.getFirstCatFromTitle(name: categoryButton.titleLabel?.text?.components(separatedBy: separator)[0] ?? ""),
                                           secondCategory_Id: secondCatInt,
                                           amount: amount,
                                           date: String(dateAndTime.prefix(10)),
                                           time: String(dateAndTime.suffix(5)),
                                           payee: payeeTextField.text ?? "",
                                           memo: memoTextField.text ?? "")
            
            
        } else {                                                        //Inserting

            
            AccountVC.db.insertTransaction(name: itemNameTextField.text ?? "",
                                           account_Id: AccountVC.db.getAccountIdFromTitle(name: accountButton.titleLabel?.text ?? ""),
                                           firstCategory_Id: AccountVC.db.getFirstCatFromTitle(name: categoryButton.titleLabel?.text?.components(separatedBy: separator)[0] ?? ""),
                                           secondCategory_Id: secondCatInt,
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
        print("TestBtn Clicked")
    
        
    }
    
    
    
    
    func onCellEditBtnClicked(editingRowId: Int) {
        print("EditorOfTransactionVC - onCellEditBtnClicked() called / indexPathFromCell = \(editingRowId)")
        editingTransactionIdFromTable = editingRowId
    }
    

    //MARK: - gestureRecognizer
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: accountButton) == true){
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
        } else if (touch.view?.isDescendant(of: textBtn) == true){
            print("Touched testBtn.")
            return true
        } else {
            print("화면이 터치되었다.")
            datePickerView.isHidden = true
            view.endEditing(true)
            return true
        }
    }
    
}
