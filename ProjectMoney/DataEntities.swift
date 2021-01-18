//
//  TransactionEntity.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import Foundation


class UserEntity {
    
    var user_ID: String
    var user_Password: String
    var name: String
    var emailAdress: String
    
    init(user_ID: String, user_Password: String, name: String, emailAdress: String) {
        
        self.user_ID = user_ID
        self.user_Password = user_Password
        self.name = name
        self.emailAdress = emailAdress
        
    }
}

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
    
    init(id: Int,
         name: String,
         account_Id: Int,
         firstCategory_Id: Int,
         secondCategory_Id: Int,
         amount: Int,
         date: String,
         time: String,
         payee: String,
         memo: String) {
        
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

