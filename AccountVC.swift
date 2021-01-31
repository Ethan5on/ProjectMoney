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
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountArrowButton: UIButton!
    
    @IBOutlet weak var backgoundButton: UIButton!
    
    
    //TableView
    @IBOutlet weak var accountTableView: UITableView!
    
    //Lower
    @IBOutlet weak var botBarAccountBtn: UIButton!
    @IBOutlet weak var botBarReportBtn: UIButton!
    @IBOutlet weak var botBarBudgetBtn: UIButton!
    @IBOutlet weak var botBarSettingsBtn: UIButton!
    
    @IBOutlet weak var botBarPlusBtn: UIButton!
    @IBOutlet weak var expenseBtn: UIButton!
    @IBOutlet weak var incomeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    //Constraints
    @IBOutlet weak var topNameBarViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var incomeBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var expenseBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBtnBottomConstraint: NSLayoutConstraint!
    
    
    //MARK: - Instances
    static var db: DatabaseManager = DatabaseManager(user_Id: user_Id_Global)
    var transactionsFromDB: [TransactionEntity] = []
    var transactionsFromDbByAccount: [TransactionEntity] = []
    var accountFromDB: [AccountEntity] = []
    var firstCategoryFromDB: [FirstCategoryEntity] = []
    var secondCategoryFromDB: [SecondCategoryEntity] = []
    
    var editingRowId: Int = 0
    
    var dataFormatter: DataFormatter = DataFormatter()
        
    private let refreshControl = UIRefreshControl()
    
    //MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
                
        uiConfig()

        refreshView()
        refreshController()
        accountMenus()
        
        self.accountTableView.delegate = self
        self.accountTableView.dataSource = self
        
//        let baseAccount = ["Cash","NatWest","HSBC","Lloyds","Santander","Barclays"]
//        let baseCatFirst = ["Food","Car","Entertainment","Online","Learning","Monthly","Shopping"]
//
//        for i in baseAccount{
//        AccountVC.db.insertAccount(name: i)
//        }
//
//        for i in baseCatFirst{
//        AccountVC.db.insertFirstCategory(name: i)
//        }
//
//        AccountVC.db.insertSecondCategory(name: "Beverage", firstCategory_Id: 1)
//        AccountVC.db.insertSecondCategory(name: "Meal", firstCategory_Id: 1)
//        AccountVC.db.insertSecondCategory(name: "Grocery", firstCategory_Id: 1)
//        AccountVC.db.insertSecondCategory(name: "Beverage", firstCategory_Id: 1)
//        AccountVC.db.insertSecondCategory(name: "Application", firstCategory_Id: 4)
//        AccountVC.db.insertSecondCategory(name: "Game Cash", firstCategory_Id: 4)
//        AccountVC.db.insertSecondCategory(name: "Electronics", firstCategory_Id: 7)
//        AccountVC.db.insertSecondCategory(name: "Cloth", firstCategory_Id: 7)
        
        
    }
    
    @objc
    private func refreshController() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        accountTableView.addSubview(refreshControl)
    }

    //MARK: - UI Configuration
    fileprivate func uiConfig() {
        
        botBarPlusBtn.layer.cornerRadius = botBarPlusBtn.frame.height / 2
        cancelBtn.layer.cornerRadius = cancelBtn.frame.height / 2
        incomeBtn.layer.cornerRadius = incomeBtn.frame.height / 2
        expenseBtn.layer.cornerRadius = expenseBtn.frame.height / 2
        searchBtn.layer.cornerRadius = searchBtn.frame.height / 2
        
        cancelBtn.isHidden = true
        incomeBtn.isHidden = true
        expenseBtn.isHidden = true
        searchBtn.isHidden = true
        backgoundButton.isHidden = true
        
    }
    
    @objc
    fileprivate func refreshView() {
        print("AccountVC - refreshView() called")
        
        
        //table view update

        accountFromDB = AccountVC.db.readAccount()
        transactionsFromDB = AccountVC.db.readTransaction()

        if accountNameLabel.text != "MONEY CLIP" {
            let accountId: Int = accountFromDB.filter{ $0.name == accountNameLabel.text! }[0].id
            
            transactionsFromDbByAccount = transactionsFromDB.filter{ $0.account_Id == accountId}
            transactionsFromDB = transactionsFromDbByAccount
        }
        firstCategoryFromDB = AccountVC.db.readFirstCategory()
        secondCategoryFromDB = AccountVC.db.readSecondCategoy()
        
        accountTableView.reloadData()
        
        //balance label update
        var balance: Int = 0
        if transactionsFromDB.count != 0 {
            for i in transactionsFromDB {
                balance += i.amount
            }
        }
        self.balanceLabel.text = dataFormatter.currencyFormatter(inputValue: balance)
        self.refreshControl.endRefreshing()
    }
    
    func exchangeMainView(viewControllerId: String) {
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: viewControllerId)
        uvcs.modalPresentationStyle = .fullScreen
        self.present(uvcs, animated: false, completion: nil)
    }
  
    
    @objc
    private func accountMenus() {
        print("EditorOfTransactionVC - accountMenus() called")

    
        accountArrowButton.showsMenuAsPrimaryAction = true
        var accounts: [String] = []
        for i in accountFromDB {
            accounts.append(i.name)
        }

        func uiElementArray(name: [String]) -> [UIMenuElement] {
            
            var result: [UIMenuElement] = []
            for i in name {
                result.append(UIAction(title: i, handler: { _ in self.accountNameLabel.text = i
                                                            self.refreshView() }))
            }
            result.append(UIAction(title: "Add", attributes: .destructive, handler: { _ in self.addAccount() }))
            return result
        }
        
        accountArrowButton.menu = UIMenu(title: "Account",
                                    image: nil,
                                    identifier: nil,
                                    options: .destructive,
                                    children: uiElementArray(name: accounts))
    }

    
    @objc
    func addAccount() {
        print("addAcount() called")
    }
    
    //MARK: - IBAction Bottom Bar Buttons

    //Bottom Bar
    @IBAction func botBarAccountBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func botBarReporBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "ReportVCId")
    }
   
    @IBAction func botBarBudgetBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "BudgetVCId")
    }
    
    @IBAction func botBarSettingsBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "naviToSettings")
    }
    
    
    //Plus Button
    @IBAction func botBarPlusBtnClicked(_ sender: UIButton) {
        print("botBarPlusBtnClicked")
        
        self.cancelBtn.isHidden = false
        self.incomeBtn.isHidden = false
        self.expenseBtn.isHidden = false
        self.searchBtn.isHidden = false
        self.backgoundButton.isHidden = false

        
        self.botBarPlusBtn.isHidden = true
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.2, animations: {
            self.cancelBtn.transform = self.cancelBtn.transform.rotated(by: CGFloat(Double.pi / 4))
            self.botBarPlusBtn.transform = self.botBarPlusBtn.transform.rotated(by: CGFloat(Double.pi / 4))
            self.expenseBtnBottomConstraint.constant = 50
            self.incomeBtnBottomConstraint.constant = 100
            self.searchBtnBottomConstraint.constant = 150
            self.plusViewHeightConstraint.constant = 190
            self.view.layoutIfNeeded()
        })
    }
    
    
    private func onPlusBtnDefaultPosition(targetBtn: UIButton, isFuntional: Bool) {
        
        self.botBarPlusBtn.isHidden = false
        self.backgoundButton.isHidden = true
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.25, animations: {
            if isFuntional == true {
                targetBtn.transform = targetBtn.transform.rotated(by: CGFloat(Double.pi))
                targetBtn.transform = targetBtn.transform.rotated(by: CGFloat(Double.pi))
            }
            self.cancelBtn.transform = self.cancelBtn.transform.rotated(by: CGFloat(Double.pi / 4 * 3))
            self.botBarPlusBtn.transform = self.botBarPlusBtn.transform.rotated(by: CGFloat(Double.pi / 4 * 3))
            self.incomeBtnBottomConstraint.constant = 0
            self.expenseBtnBottomConstraint.constant = 0
            self.searchBtnBottomConstraint.constant = 0
            self.plusViewHeightConstraint.constant = 40
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func searchBtnOnPlusClicked(_ sender: UIButton) {
        print("searchBtnOnPlusClicked")
        
        onPlusBtnDefaultPosition(targetBtn: searchBtn, isFuntional: true)

        //Temporary Log Out Button
        LoginVC.db.deleteRememberUser(id: user_Id_Global)
        exchangeMainView(viewControllerId: "naviToLoginVCId")
    }
    
    
    @IBAction func incomeBtnOnPlusClicked(_ sender: UIButton) {
        print("incomBtnOnPlusClicked")
        
        onPlusBtnDefaultPosition(targetBtn: incomeBtn, isFuntional: true)
        
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: "EditorOfTransactionVCId") as! EditorOfTransactionVC
        
        uvcs.newTransactionUpdateDelegate = self
        uvcs.onEditorPopUpSegueIndex = 1
        self.present(uvcs, animated: true, completion: nil)
    }
    
    
    @IBAction func expenseBtnOnPlusClicked(_ sender: UIButton) {
        print("expenseBtnOnPlusClicked")
        
        onPlusBtnDefaultPosition(targetBtn: expenseBtn, isFuntional: true)
        
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: "EditorOfTransactionVCId") as! EditorOfTransactionVC
        
        uvcs.newTransactionUpdateDelegate = self
        uvcs.onEditorPopUpSegueIndex = 0
        self.present(uvcs, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancelBtnOnPlusClicked(_ sender: UIButton) {
        print("cancelBtnOnPlusClicked")
        
        onPlusBtnDefaultPosition(targetBtn: cancelBtn, isFuntional: false)
    }
    
    
    @IBAction func backgoundBtnClicked(_ sender: UIButton) {
        print("backgoundBtnClicked")
        
        onPlusBtnDefaultPosition(targetBtn: backgoundButton, isFuntional: false)
    }

    
 
    
    //MARK: - Delegates
    func onEditorVCCircleBtnClicked() {
        print("AccountView - onEdiotVCCircleBtnClicked() called")
        print("New transaction is updated on table")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {self.refreshView()})
    }
}



//MARK: - Table View - Delegate
extension AccountVC: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.contains(indexPath) {
            return 100
        } else {
            return 50
        }
    }

    
    
    //MARK: - Swipe Action
    private func handleGoToDetails() {
        print("Went to Details")
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: "EditorOfTransactionVCId") as! EditorOfTransactionVC
        uvcs.onCellEditBtnClicked(editingRowId: editingRowId)
        self.present(uvcs, animated: true, completion: nil)
    }

    private func handleGoToEditor() {
        print("Went to Editor")
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: "EditorOfTransactionVCId") as! EditorOfTransactionVC
        uvcs.newTransactionUpdateDelegate = self
        uvcs.onCellEditBtnClicked(editingRowId: editingRowId)
        self.present(uvcs, animated: true, completion: nil)
    }

    private func handleMoveToTrash() {
        print("Moved to trash")
        AccountVC.db.deleteTransactionById(id: editingRowId)
        refreshView()
    }
    

    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Trash action
        let trash = UIContextualAction(style: .normal,
                                         title: "Trash") { [weak self] (action, view, completionHandler) in
                                            self?.handleMoveToTrash()
                                            completionHandler(true)
        }
        trash.backgroundColor = .systemRed

        // Edit action
        let edit = UIContextualAction(style: .destructive,
                                       title: "Edit") { [weak self] (action, view, completionHandler) in
                                        self?.handleGoToEditor()
                                        completionHandler(true)
        }
        edit.backgroundColor = .systemBlue

        // Details action
        let details = UIContextualAction(style: .normal,
                                       title: "Details") { [weak self] (action, view, completionHandler) in
                                        self?.handleGoToDetails()
                                        completionHandler(true)
        }
        details.backgroundColor = .systemGray

        // get id
        var yearAndMonth: Set<String> = []
        for transaction in transactionsFromDB {
            yearAndMonth.insert(String(transaction.date.prefix(7)))
        }
        let header = Array(yearAndMonth.sorted().reversed())[indexPath.section]
        print(transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].id)
        editingRowId = transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].id

        print(transactionsFromDB.filter{ $0.id == editingRowId }[0].name)
        
        let configuration = UISwipeActionsConfiguration(actions: [trash, edit, details])

        return configuration
    }
    
}

//MARK: - Table View - DataSource
extension AccountVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        var yearAndMonth: Set<String> = []
        for transaction in transactionsFromDB {
            yearAndMonth.insert(String(transaction.date.prefix(7)))
        }
        return yearAndMonth.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var yearAndMonth: Set<String> = []
        for transaction in transactionsFromDB {
            yearAndMonth.insert(String(transaction.date.prefix(7)))
        }
        return String(yearAndMonth.sorted().reversed()[section])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var yearAndMonth: Array<String> = []
        for transaction in transactionsFromDB {
            yearAndMonth.append(String(transaction.date.prefix(7)))
        }
        let header = Set(yearAndMonth).sorted().reversed()[section]

        return  yearAndMonth.filter{ $0.prefix(7) == header }.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var yearAndMonth: Set<String> = []
        for transaction in transactionsFromDB {
            yearAndMonth.insert(String(transaction.date.prefix(7)))
        }

        let header = yearAndMonth.sorted().reversed()[indexPath.section]
        
        let cell = accountTableView.dequeueReusableCell(withIdentifier: "accountTableViewCellId", for: indexPath) as! AccountTableViewCell
        
        cell.cellItemName.text = transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].name
        cell.cellAmount.text = dataFormatter.currencyFormatter(inputValue: transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].amount)
        cell.cellTransactionDateTime.text = "\(transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].date), \(transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].time)"
        cell.cellAccount.text = accountFromDB.filter{ $0.id == transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].account_Id}[0].name
        
        var secondCat: String
        if secondCategoryFromDB.filter({ $0.id == transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].secondCategory_Id}).count != 1 {
            secondCat = ""
        } else {
            secondCat = " > \(secondCategoryFromDB.filter{ $0.id == transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].secondCategory_Id}[0].name)"
        }
        cell.cellCategory.text = "\(firstCategoryFromDB.filter{ $0.id == transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].firstCategory_Id}[0].name)\(secondCat)"
        cell.cellPayee.text = transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].payee
        cell.cellMemo.text = transactionsFromDB.filter{ $0.date.prefix(7) == header }[indexPath.row].memo

        
        return cell
    }
    
    
}

//MARK: - Top Name Bar Hide Extension
extension AccountVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let maxConstraintWhenScrollDown: CGFloat = -40
        
        let y: CGFloat = scrollView.contentOffset.y
        let newTopNameBarViewConstraint: CGFloat = topNameBarViewConstraint.constant - y
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            if newTopNameBarViewConstraint > maxConstraintWhenScrollDown {      //hide
                
                self.topNameBarViewConstraint.constant = 0
                self.view.layoutIfNeeded()
            } else {                        //appear
                self.topNameBarViewConstraint.constant = maxConstraintWhenScrollDown
                self.view.layoutIfNeeded()
                
            }
        })
    }
}
