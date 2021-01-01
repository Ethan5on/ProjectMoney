//
//  EditorOfTransactionVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import UIKit

class EditorOfTransactionVC: UIViewController {
    
    //MARK: - Upper Bar Buttons
    @IBOutlet weak var backArrowBtn: UIButton!
    @IBOutlet weak var circleBtn: UIButton!
    @IBOutlet weak var ExpIncSegument: UISegmentedControl!
    
    
    
    var newTransactionUpdateDelegate : EventDataTransactionDelegate?
    
    var onEditorPopUpSegueIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExpIncSegument?.selectedSegmentIndex = onEditorPopUpSegueIndex
//        print("onEditorOfTransactionVC's Seguement Index = \(ExpIncSeguement.selectedSegmentIndex)")
    }
    
    //MARK: - IBAction Upper Bar Buttons
    @IBAction func backArrowBtnClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func circleBtnClicked(_ sender: UIButton) {
        newTransactionUpdateDelegate?.onEditorVCCircleBtnClicked()
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
