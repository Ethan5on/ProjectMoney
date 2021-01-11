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
    
    @IBOutlet weak var botBarPlusBtn: UIButton!
    
    @IBOutlet weak var botBarBudgetBtn: UIButton!
    @IBOutlet weak var botBarSettingsBtn: UIButton!
    
    
    //MARK: - ViewDidLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiConfig()
        
    }

    //MARK: - UI Configuration
    fileprivate func uiConfig() {
        
        botBarPlusBtn.layer.cornerRadius = botBarPlusBtn.frame.height / 2
        
    }
    
    //MARK: - IBAction Bottom Bar Buttons

    @IBAction func botBarAccountBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "AccountVCId")
    }
    @IBAction func botBarReporBtnClicked(_ sender: UIButton) {
        exchangeMainView(viewControllerId: "ReportVCId")
    }
    @IBAction func botBarPlusBtnClicked(_ sender: UIButton) {
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: "PlusBtnPopUpVCId")
        self.present(uvcs, animated: true, completion: nil)
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

