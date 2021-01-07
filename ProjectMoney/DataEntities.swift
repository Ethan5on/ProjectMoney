//
//  TransactionEntity.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import Foundation

class TransactionEntity {
    
    var id: Int
    var name: String
    var account_Id: Int
    var firstCategory_Id: Int
    var secondCategory_Id: Int
    var amount: Int
    var date: String
    var time: String
    var payee: String
    var memo: String
    
    init(id: Int, name: String, account_Id: Int, firstCategory_Id: Int, secondCategory_Id: Int, amount: Int, date: String, time: String, payee: String, memo: String) {
        
        self.id = id
        self.name = name
        self.account_Id = account_Id
        self.firstCategory_Id = firstCategory_Id
        self.secondCategory_Id = secondCategory_Id
        self.amount = amount
        self.date = date
        self.time = time
        self.payee = payee
        self.memo = memo
    }
}

class AccountEntity {
    
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        
        self.id = id
        self.name = name
        
    }
}

class FirstCategoryEntity {
    
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        
        self.id = id
        self.name = name
        
    }
}


class SecondCategoryEntity {
    
    var id: Int
    var name: String
    var firstCategory_Id: Int
    
    init(id: Int, name: String, firstCategory_Id: Int) {
        
        self.id = id
        self.name = name
        self.firstCategory_Id = firstCategory_Id
        
    }
}
