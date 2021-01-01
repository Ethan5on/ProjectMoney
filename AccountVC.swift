//
//  ViewController.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2020/12/15.
//

import UIKit

class AccountVC: UIViewController, EventDataTransactionDelegate {

    //MARK: - IBOulets
    //Upper
    @IBOutlet weak var balanceLabel: UILabel!
    

    
    //TableView
    @IBOutlet weak var accountTableView: UITableView!
    
    
    //Lower
    @IBOutlet weak var botBarAccountBtn: UIButton!
    @IBOutlet weak var botBarReportBtn: UIButton!
    
    @IBOutlet weak var botBarPlusBtn: UIButton!
    
    @IBOutlet weak var botBarBudgetBtn: UIButton!
    @IBOutlet weak var botBarSettingsBtn: UIButton!
    
    
    
    
    //MARK: - Instances
    static var db: DatabaseManager = DatabaseManager()
    var ts: [TransactionEntity] = []
    var ac: [AccountEntity] = []
    var fc: [FirstCategoryEntity] = []
    var sc: [SecondCategoryEntity] = []
    
    
    //MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        
        AccountVC.db.insertTransaction(id: 1, name: "asdfasdf", account_Id: 0, firstCategory_Id: 0, secondCategory_Id: 0, amount: 241688, date: "2012.12.31", time: "11:28", payee: "asdf", memo: "asdfasdf")

        
        ts = AccountVC.db.readTransaction()
        ac = AccountVC.db.readAccount()
        fc = AccountVC.db.readFirstCategory()
        sc = AccountVC.db.readSecondCategoy()
        
        
//        self.accountTableView.register(AccountVC.self, forCellReuseIdentifier: "accountTableViewCellId")
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
    }

    //MARK: - UI Configuration
    fileprivate func uiConfig() {
        
        botBarPlusBtn.layer.cornerRadius = botBarPlusBtn.frame.height / 2
        
    }
    
    //MARK: - IBAction Bottom Bar Buttons

    @IBAction func botBarAccountBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func botBarReporBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "ReportVCId")
    }
    
    @IBAction func botBarPlusBtnClicked(_ sender: UIButton) {
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: "PlusBtnPopUpVCId") as! PlusBtnPopUpVC
        uvcs.toEditorDelegate = self
        self.present(uvcs, animated: true, completion: nil)
    }
    
    @IBAction func botBarBudgetBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "BudgetVCId")
    }
    
    @IBAction func botBarSettingsBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "SettingsVCId")
    }
    
    func exchangeMainView(viewControllerId: String) {
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: viewControllerId)
        uvcs.modalPresentationStyle = .fullScreen
        self.present(uvcs, animated: false, completion: nil)
    }
    
    //MARK: - Delegates
    func onPlusPopUpVCBtnClicked(segueIndex: Int) {
        
        print("AccountView - onEdiotVCCircleBtnClicked() called / segueIndex = \(segueIndex)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            
            let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
            let uvcs = storyboards.instantiateViewController(identifier: "EditorOfTransactionVCId") as! EditorOfTransactionVC
            
            uvcs.newTransactionUpdateDelegate = self
            uvcs.onEditorPopUpSegueIndex = segueIndex
            self.present(uvcs, animated: true, completion: nil)
            
        })
        
        
    }
    
    func onEditorVCCircleBtnClicked() {
        print("AccountView - onEdiotVCCircleBtnClicked() called")
        print("New transaction is updated on table")
    }
    
    
    
}



//MARK: - Table View Extensions
extension AccountVC: UITableViewDelegate {
    
}

extension AccountVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = accountTableView.dequeueReusableCell(withIdentifier: "accountTableViewCellId", for: indexPath) as! AccountTableViewCell
        cell.cellItemName.text = ts[indexPath.row].name
        cell.cellAmount.text = String(ts[indexPath.row].amount)
        cell.cellTransactionDateTime.text = "\(ts[indexPath.row].date), \(ts[indexPath.row].time)"
        return cell
    }
    
    
}

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var cellCategoryImage: UIImageView!
    @IBOutlet weak var cellItemName: UILabel!
    @IBOutlet weak var cellTransactionDateTime: UILabel!
    @IBOutlet weak var cellAmount: UILabel!
}
