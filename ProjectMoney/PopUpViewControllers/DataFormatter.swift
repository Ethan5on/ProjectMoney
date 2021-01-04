//
//  DataFormatter.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/05.
//

import Foundation

class DataFormatter {
    
    func dateFormatter(inputValue: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let result = formatter.string(from: inputValue)
        return result
        
    }
    
    func timeFormatter(inputValue: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let result = formatter.string(from: inputValue)
        return result
    }
    
    func currencyFormatter(inputValue: Int) -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let result = formatter.string(from: NSNumber(value: inputValue))!
        return result
    }
}
