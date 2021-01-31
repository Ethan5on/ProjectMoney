//
//  CreateCategoryVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/31.
//

import Foundation
import UIKit

class CreateCategoryVC: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var backGroundButton: UIButton!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var firstOfSecondCatSegment: UISegmentedControl!
    @IBOutlet weak var nameOfCategoryTextField: UITextField!
    @IBOutlet weak var subcategoryButton: UIButton!
    
    var firstCategoryFromDB: [FirstCategoryEntity] = []
    
    var categoryChangedDelegate: CreateCategoryVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 15
        firstCategoryFromDB = AccountVC.db.readFirstCategory()
        firstCategoryMenus()
        
    }

    
    @objc private func firstCategoryMenus() {
        print("Subcategory Button Clicked")

        subcategoryButton.showsMenuAsPrimaryAction = true
        var categories: [String] = []
        for i in firstCategoryFromDB {
           categories.append(i.name)
        }

        func uiElementArray(name: [String]) -> [UIMenuElement] {
            
            var result: [UIMenuElement] = []
            for i in name {
                result.append(UIAction(title: i, handler: { _ in self.subcategoryButton.setTitle(i, for: .normal)}))
            }
            return result
        }
        
        subcategoryButton.menu = UIMenu(title: "Primary Categories",
                                    image: nil,
                                    identifier: nil,
                                    options: .destructive,
                                    children: uiElementArray(name: categories))
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        switch firstOfSecondCatSegment.selectedSegmentIndex {
        case 0:
            subcategoryButton.isUserInteractionEnabled = false
            subcategoryButton.tintColor = .systemGray
            subcategoryButton.titleLabel?.text = "None"
        case 1:
            subcategoryButton.isUserInteractionEnabled = true
            subcategoryButton.tintColor = .systemBlue
        default:
            print("Error")
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func backGroundButtonClicked(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func circleButtonClicked(_ sender: UIButton) {
        
        guard nameOfCategoryTextField.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "Insert name of category", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            return
        }
        
        switch firstOfSecondCatSegment.selectedSegmentIndex {
        case 0:
            AccountVC.db.insertFirstCategory(name: nameOfCategoryTextField.text!)
        case 1:
            
            guard subcategoryButton.titleLabel?.text != "None" else {
                
                let alert = UIAlertController(title: nil, message: "Select Primary Category", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                return
            }
            
            let firstCatId: Int = firstCategoryFromDB.filter{ $0.name == subcategoryButton.titleLabel?.text }[0].id
            AccountVC.db.insertSecondCategory(name: nameOfCategoryTextField.text!, firstCategory_Id: firstCatId)
            
        default:
            print("Error")
            
        }
        categoryChangedDelegate?.onCreateCategoryVCCircleBtnClicked()
        dismiss(animated: true, completion: nil)
        
    }
}


