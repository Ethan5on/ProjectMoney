//
//  CategoryVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/28.
//

import Foundation
import UIKit

class CategoryVC: UIViewController, CreateCategoryVCDelegate {
    
    
    @IBOutlet weak var firstCategoryTableView: UITableView!
    @IBOutlet weak var secondCategoryTableView: UITableView!
    @IBOutlet weak var firstCatTableWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var plusButton: UIButton!
    
    var firstCategoryFromDB: [FirstCategoryEntity] = []
    var secondCategoryFromDB: [SecondCategoryEntity] = []
    var secondCatTableArray: [String] = []
    
    let barEditButton: UINavigationItem = UINavigationItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstCategoryFromDB = AccountVC.db.readFirstCategory()
        secondCategoryFromDB = AccountVC.db.readSecondCategoy()
        
        firstCategoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "firstCategoryCell")
        secondCategoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "secondCategoryCell")
        
        self.firstCategoryTableView.dataSource = self
        self.firstCategoryTableView.delegate = self
        self.secondCategoryTableView.dataSource = self
        self.secondCategoryTableView.delegate = self
        
        firstCatTableWidthConstraint.constant = view.frame.width
        plusButton.layer.cornerRadius = plusButton.frame.height / 2
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(naviBarEditBtnClicked))
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    
    @objc
    private func naviBarEditBtnClicked(sender: UIBarButtonItem) {
        print("Delete Button Clicked()")
        

        
        if self.firstCategoryTableView.isEditing != true {
            firstCategoryTableView.setEditing(true, animated: true)
            secondCategoryTableView.setEditing(true, animated: true)
            navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            firstCategoryTableView.setEditing(false, animated: true)
            secondCategoryTableView.setEditing(false, animated: true)
            navigationItem.rightBarButtonItem?.title = "Delete"
        }
        
    }
    
    
    @objc
    fileprivate func refreshView() {
        print("refreshView() called")
        
        //table view update
        firstCategoryFromDB = AccountVC.db.readFirstCategory()
        secondCategoryFromDB = AccountVC.db.readSecondCategoy()
        
        firstCategoryTableView.reloadData()
        secondCategoryTableView.reloadData()
    }
    
    @IBAction func plusButtonClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.plusButton.transform = self.plusButton.transform.rotated(by: CGFloat(Double.pi))
            self.view.layoutIfNeeded()
        })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
        let storyboards = UIStoryboard.init(name: "Main", bundle: nil)
        let uvcs = storyboards.instantiateViewController(identifier: "CreateCategoryVCId") as! CreateCategoryVC
        uvcs.modalPresentationStyle = .overFullScreen
        uvcs.categoryChangedDelegate = self
        self.present(uvcs, animated: true, completion: nil)

//        })
    }
    
    func onCreateCategoryVCCircleBtnClicked() {
        print("Delegate : CategoryVC - onCreateCategoryVCCircleBtnClicked() called")
        refreshView()
    }

}



extension CategoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            if tableView == firstCategoryTableView {
                
                print("First category table - Deleted row at \(indexPath)")
                let titleLabel: String = (firstCategoryTableView.cellForRow(at: indexPath)?.textLabel?.text)!
                let firstCatId: Int = firstCategoryFromDB.filter{ $0.name == titleLabel }[0].id
                AccountVC.db.deleteFirstCategoryById(id: firstCatId)
                
                var subCatIdArray: [Int] = []
                
                for secondCat in secondCategoryFromDB {
                    if secondCat.firstCategory_Id == firstCatId {
                    subCatIdArray.append(secondCat.id)
                    }
                }
                for subCatId in subCatIdArray {
                    AccountVC.db.deleteSecondCategoryById(id: subCatId)
                }
                
                //Need to delete on Transaction !!!!!!!!!!!!!!!!
                
            } else if tableView == secondCategoryTableView {
                
                print("Second category table - Deleted row at \(indexPath)")
                let titleLabel: String = (secondCategoryTableView.cellForRow(at: indexPath)?.textLabel?.text)!
                let secondCatId: Int = secondCategoryFromDB.filter{ $0.name == titleLabel }[0].id
                AccountVC.db.deleteSecondCategoryById(id: secondCatId)
            }
        }
        self.refreshView()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == firstCategoryTableView {
        
            secondCatTableArray = []

            let title = tableView.cellForRow(at: indexPath)?.textLabel?.text!
            let firstCatId = firstCategoryFromDB.filter{ $0.name == title }[0].id
            let entity = secondCategoryFromDB.filter{ $0.firstCategory_Id == firstCatId }
            for i in entity {
                self.secondCatTableArray.append(i.name)
            }
            
            UIView.animate(withDuration: 0.4, animations: {
                if self.secondCatTableArray.count == 0 {
                    self.firstCatTableWidthConstraint.constant = self.view.frame.width
                } else {
                    self.firstCatTableWidthConstraint.constant = self.view.frame.width / 2
                }
                self.view.layoutIfNeeded()
            })
            secondCategoryTableView.reloadData()
        }
    }
}

extension CategoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch tableView {
        case firstCategoryTableView:
            return self.firstCategoryFromDB.count

        case secondCategoryTableView:
            return self.secondCatTableArray.count
            
        default:
            fatalError("Invalid table")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case firstCategoryTableView:
            let firstCatCell = firstCategoryTableView.dequeueReusableCell(withIdentifier: "firstCategoryCell", for: indexPath)
            
            firstCatCell.textLabel?.text = firstCategoryFromDB[indexPath.row].name
            firstCatCell.imageView?.image = UIImage(systemName: "cart")
            
            return firstCatCell
        case secondCategoryTableView:
            
            let secondCatCell = secondCategoryTableView.dequeueReusableCell(withIdentifier: "secondCategoryCell", for: indexPath)
            
            secondCatCell.textLabel?.text = secondCatTableArray[indexPath.row]
            
            return secondCatCell
            
        default:
            fatalError("Invalid table")
        }
        
    }
    
    
    
}
