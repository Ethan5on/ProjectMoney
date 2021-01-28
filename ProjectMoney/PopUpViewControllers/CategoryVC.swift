//
//  CategoryVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/28.
//

import Foundation
import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var firstCategoryTableView: UITableView!
    @IBOutlet weak var secondCategoryTableView: UITableView!
    @IBOutlet weak var firstCatTableWidthConstraint: NSLayoutConstraint!
    
    var firstCategoryFromDB: [FirstCategoryEntity] = []
    var secondCategoryFromDB: [SecondCategoryEntity] = []
    var secondCatTableArray: [String] = []
    
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
        
    }
    
    
    
    
}


extension CategoryVC: UITableViewDelegate {
    
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
