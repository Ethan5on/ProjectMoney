//
//  SettingsTVC.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/12.
//

import UIKit


class SettingsTVC: UITableViewController {
    
    
    var menu: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        
        menu = ["Account", "Categories", "Delete All", "About", "Log out"]
        
    }
    
    
    private func registerCell() {
        let cell = UINib(nibName: "SettingsStaticCellTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "SettingsCellId")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCellId") as? SettingsStaticCellTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = menu[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("0")
        case 1:
            print("1")
        case 2:
            print("2")
        default:
            print("default")
        }
    }
}
