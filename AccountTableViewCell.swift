//
//  AccountTableViewCell.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/02.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellCategoryImage: UIImageView!
    @IBOutlet weak var cellItemName: UILabel!
    @IBOutlet weak var cellTransactionDateTime: UILabel!
    @IBOutlet weak var cellAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellCategoryImage.layer.cornerRadius = 10
    }
}
