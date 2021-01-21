//
//  SettingsVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2020/12/31.
//

import UIKit

class SettingsVC: UIViewController {
    
    //MARK: - BottomBarButtons
    @IBOutlet weak var botBarAccountBtn: UIButton!
    @IBOutlet weak var botBarReportBtn: UIButton!
    @IBOutlet weak var botBarBudgetBtn: UIButton!
    @IBOutlet weak var botBarSettingsBtn: UIButton!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    let settignsMenus: [String] = ["Categories", "About", "Log Out", "Delete All Data"]
    
    //MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        
    }

    //MARK: - UI Configuration
    fileprivate func uiConfig() {
            
    }
    
    //MARK: - IBAction Bottom Bar Buttons

    @IBAction func botBarAccountBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "AccountVCId")
    }
    @IBAction func botBarReporBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "ReportVCId")
    }
    @IBAction func botBarBudgetBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "BudgetVCId")
    }
    @IBAction func botBarSettingsBtnClicked(_ sender: UIButton) {
    }
    
    func exchangeMainView(viewControllerId: String) {
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: viewControllerId)
        uvcs.modalPresentationStyle = .fullScreen
        self.present(uvcs, animated: false, completion: nil)
    }
    
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print(0)
        case 1:
            print(1)
            
        //Log Out
        case 2:
            
            let alert = UIAlertController(title: nil, message: "Log Out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                LoginVC.db.deleteRememberUser(id: user_Id_Global)
                self.exchangeMainView(viewControllerId: "LoginVCId")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil ))

            self.present(alert, animated: true)
            
        case 3:
            print(3)
        default:
            print("defalut")
        }
    }
}

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settignsMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = settignsMenus[indexPath.row]
        return cell
    }
}
