//
//  aboutVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/27.
//

import Foundation
import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var myEmailAddressBtn: UIButton!
    @IBOutlet weak var myIntroduceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myProfileImageView.layer.cornerRadius = myProfileImageView.frame.height / 2
        
    }
    
    
    
}
