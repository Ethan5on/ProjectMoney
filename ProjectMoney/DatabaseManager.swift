//
//  DataBaseManager.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import Foundation
import SQLite3

class DatabaseManager {
 
    init() {
        
        db = openDatabase()
        createTransactionTable()
        createAccountTable()
        createFirstCategoryTable()
        createSecondCategoryTable()
    }
    
    let dbPath: String = "Transaction.sqlite"
    var db: OpaquePointer?
    
    
    //MARK: - Open Database
    func openDatabase() -> OpaquePointer? {
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer?
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
        
    }
    
    //MARK: - Create Table Functions
    //transaction
    func createTransactionTable() {
        
        let createTableStatementString = "CREATE TABLE IF NOT EXISTS deal(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, account_Id INTEGER, firstCategory_Id INTERGER, secondCategory_Id INTEGER, amount INTEGER, date TEXT, time TEXT, payee TEXT, memo TEXT);"
        var createTableStatement : OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableStatementString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("transaction table created")
            } else {
                print("transaction table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    //account
    func createAccountTable() {
        
        let createTableStatementString = "CREATE TABLE IF NOT EXISTS account(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);"
        var createTableStatement : OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableStatementString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("account table created")
            } else {
                print("account table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    //1st category
    func createFirstCategoryTable() {
        
        let createTableStatementString = "CREATE TABLE IF NOT EXISTS firstCategory(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, secondCategory_Id INTEGER);"
        var createTableStatement : OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableStatementString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("firstCategory table created")
            } else {
                print("firstCategory table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    //2nd category
    func createSecondCategoryTable() {
        
        let createTableStatementString = "CREATE TABLE IF NOT EXISTS secondCategory(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);"
        var createTableStatement : OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableStatementString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("secondCategory table created")
            } else {
                print("secondCategory table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK: - Insert Functions
    //transaction
    func insertTransaction(id: Int,
                           name: String,
                           account_Id: Int,
                           firstCategory_Id: Int,
                           secondCategory_Id: Int,
                           amount: Int,
                           date: String,
                           time: String,
                           payee: String,
                           memo: String) {
        
        let ts = readTransaction()
        for p in ts {
            if p.id == id{
                return
            }
        }
        let insertTransactionStatementString = "INSERT INTO deal(name, account_Id, firstCategory_Id, secondCategory_Id, amount, date, time, payee, memo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertTransactionStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertTransactionStatementString, -1, &insertTransactionStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertTransactionStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertTransactionStatement, 2, Int32(account_Id))
            sqlite3_bind_int(insertTransactionStatement, 3, Int32(firstCategory_Id))
            sqlite3_bind_int(insertTransactionStatement, 4, Int32(secondCategory_Id))
            sqlite3_bind_int(insertTransactionStatement, 2, Int32(amount))
            sqlite3_bind_text(insertTransactionStatement, 6, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertTransactionStatement, 7, (time as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertTransactionStatement, 8, (payee as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertTransactionStatement, 9, (memo as NSString).utf8String, -1, nil)

            if sqlite3_step(insertTransactionStatement) == SQLITE_DONE {
                print("Successfully inserted row")
            } else {
                print("Could not insert row")
            }
        } else {
            print("INSERT statement could not prepared")
        }
        sqlite3_finalize(insertTransactionStatement)
    }
    
    
    //account
    func insertAccount(id: Int,
                           name: String) {
        
        let ts = readAccount()
        for p in ts {
            if p.id == id{
                return
            }
        }
        let insertTransactionStatementString = "INSERT INTO account(name) VALUES (?);"
        var insertTransactionStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertTransactionStatementString, -1, &insertTransactionStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertTransactionStatement, 1, (name as NSString).utf8String, -1, nil)

            if sqlite3_step(insertTransactionStatement) == SQLITE_DONE {
                print("Successfully inserted row")
            } else {
                print("Could not insert row")
            }
        } else {
            print("INSERT statement could not prepared")
        }
        sqlite3_finalize(insertTransactionStatement)
    }
    
    
    //1stCategory
    func insertFirstCategory(id: Int,
                           name: String,
                           secondCategory_Id: Int) {
        
        let ts = readFirstCategory()
        for p in ts {
            if p.id == id{
                return
            }
        }
        let insertTransactionStatementString = "INSERT INTO firstCategory(name, secondCategory_Id) VALUES (?, ?;"
        var insertTransactionStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertTransactionStatementString, -1, &insertTransactionStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertTransactionStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertTransactionStatement, 2, Int32(secondCategory_Id))

            if sqlite3_step(insertTransactionStatement) == SQLITE_DONE {
                print("Successfully inserted row")
            } else {
                print("Could not insert row")
            }
        } else {
            print("INSERT statement could not prepared")
        }
        sqlite3_finalize(insertTransactionStatement)
    }
    
    
    //2ndCategory
    func insertSecondCategory(id: Int,
                           name: String) {
        
        let ts = readSecondCategoy()
        for p in ts {
            if p.id == id {
                return
            }
        }
        let insertTransactionStatementString = "INSERT INTO secondCategory(name) VALUES (?);"
        var insertTransactionStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertTransactionStatementString, -1, &insertTransactionStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertTransactionStatement, 1, (name as NSString).utf8String, -1, nil)

            if sqlite3_step(insertTransactionStatement) == SQLITE_DONE {
                print("Successfully inserted row")
            } else {
                print("Could not insert row")
            }
        } else {
            print("INSERT statement could not prepared")
        }
        sqlite3_finalize(insertTransactionStatement)
    }
    
    
    //MARK: - Read Functions
    //transaction
    func readTransaction() -> [TransactionEntity] {
        let queryStatementString = "SELECT * FROM deal;"
        var queryStatement: OpaquePointer?
        var ts: [TransactionEntity] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let account_Id = sqlite3_column_int(queryStatement, 2)
                let firstCategory_Id = sqlite3_column_int(queryStatement, 3)
                let secondCategory_Id = sqlite3_column_int(queryStatement, 4)
                let amount = sqlite3_column_int(queryStatement, 5)
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let time = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let payee = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let memo = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                ts.append(TransactionEntity(id: Int(id), name: name, account_Id: Int(account_Id), firstCategory_Id: Int(firstCategory_Id), secondCategory_Id: Int(secondCategory_Id), amount: Int(amount), date: date, time: time, payee: payee, memo: memo))
                print("Query Result:")
                print("\(id) | \(name) | \(account_Id) | \(firstCategory_Id) | \(secondCategory_Id) | \(amount) | \(date) | \(time) | \(memo) ")
            }
        }else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return ts
    }
    
    
    //account
    func readAccount() -> [AccountEntity] {
        let queryStatementString = "SELECT * FROM account;"
        var queryStatement: OpaquePointer?
        var ac: [AccountEntity] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                ac.append(AccountEntity(id: Int(id), name: name))
                print("Query Result:")
                print("\(id) | \(name)")
            }
        }else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return ac
    }
    
    
    //1stCategory
    func readFirstCategory() -> [FirstCategoryEntity] {
        let queryStatementString = "SELECT * FROM firstCategory;"
        var queryStatement: OpaquePointer?
        var fc: [FirstCategoryEntity] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let secondCategory_Id = sqlite3_column_int(queryStatement, 2)

                fc.append(FirstCategoryEntity(id: Int(id), name: name, secondCategory_Id: Int(secondCategory_Id)))
                print("Query Result:")
                print("\(id) | \(name) | \(secondCategory_Id)")
            }
        }else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return fc
    }
    
    
    //2ndCategory
    func readSecondCategoy() -> [SecondCategoryEntity] {
        let queryStatementString = "SELECT * FROM secondCategory;"
        var queryStatement: OpaquePointer?
        var sc: [SecondCategoryEntity] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                sc.append(SecondCategoryEntity(id: Int(id), name: name))
                print("Query Result:")
                print("\(id) | \(name)")
            }
        }else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return sc
    }
    
    
    //MARK: - Delete Functions
    //transaction
    func deleteTransactionById(id: Int) {
        
        let deleteStatementString = "DELETE FROM deal WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row by id")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        
    }
    
    
    //account
    func deleteAccountById(id: Int) {
        
        let deleteStatementString = "DELETE FROM account WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row by id")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        
    }
    
    
    //1st category
    func deleteFirstCategoryById(id: Int) {
        
        let deleteStatementString = "DELETE FROM firstCategory WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row by id")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    
    }
    
    
    //2nd category
    func deleteSecondCategoryById(id: Int) {
        
        let deleteStatementString = "DELETE FROM secondCategory WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row by id")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
