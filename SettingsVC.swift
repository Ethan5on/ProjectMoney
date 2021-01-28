//
//  SettingsVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2020/12/31.
//
import MessageUI
import UIKit


class SettingsVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: - BottomBarButtons
    @IBOutlet weak var botBarAccountBtn: UIButton!
    @IBOutlet weak var botBarReportBtn: UIButton!
    @IBOutlet weak var botBarBudgetBtn: UIButton!
    @IBOutlet weak var botBarSettingsBtn: UIButton!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    let settignsMenus: [String] = ["Categories", "About", "Log Out","Bug Report", "Delete All Data"]
    
    let navi: UINavigationBar = UINavigationBar()
    //MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        
        navi.isHidden = false
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
            
            performSegue(withIdentifier: "categorySegue", sender: self)
        case 1:
            print(1)
            
            performSegue(withIdentifier: "aboutSegue", sender: self)
            
        //Log Out
        case 2:
            
            let alert = UIAlertController(title: nil, message: "Log Out", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                LoginVC.db.deleteRememberUser(id: user_Id_Global)
                self.exchangeMainView(viewControllerId: "naviToLoginVCId")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil ))

            self.present(alert, animated: true)
            
        case 3:
            print(3)
            
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
             
            // Configure the fields of the interface.
            composeVC.setToRecipients(["ethan5on@kakao.com"])
            composeVC.setSubject("Bug Report:")
//            composeVC.setMessageBody("Hello from California!", isHTML: false)
             
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
            func mailComposeController(controller: MFMailComposeViewController,
                                       didFinishWithResult result: MFMailComposeResult, error: NSError?) {
                // Check the result or perform other tasks.
                
                // Dismiss the mail compose view controller.
                controller.dismiss(animated: true, completion: nil)
            }
            
        case 4:
            let alert = UIAlertController(title: nil, message: "Delete All Data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                AccountVC.db.dropTable()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil ))

            self.present(alert, animated: true)
            
            
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
