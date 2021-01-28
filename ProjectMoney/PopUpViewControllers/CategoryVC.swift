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
    
    var firstCategoryFromDB: [FirstCategoryEntity] = []
    var secondCategoryFromDB: [SecondCategoryEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        firstCategoryFromDB = AccountVC.db.readFirstCategory()
        secondCategoryFromDB = AccountVC.db.readSecondCategoy()
        
        firstCategoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCellId")
        
        self.firstCategoryTableView.dataSource = self
        self.firstCategoryTableView.delegate = self
        
        
    }
    
    
    
    
}


extension CategoryVC: UITableViewDelegate {
    
    
}

extension CategoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.firstCategoryFromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = firstCategoryTableView.dequeueReusableCell(withIdentifier: "categoryCellId", for: indexPath)
        
        cell.textLabel?.text = firstCategoryFromDB[indexPath.row].name
        
        return cell
    }
    
    
    
}



class FirstCategoryTableViewCell: UITableViewCell {
    
    
    
}
