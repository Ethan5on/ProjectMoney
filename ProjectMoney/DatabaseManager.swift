//
//  DataBaseManager.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import Foundation
import SQLite3

class DatabaseManager {
 
    init(user_Id: String) {

        db = openDatabase(user_Id: user_Id)
        createTransactionTable()
        createAccountTable()
        createFirstCategoryTable()
        createSecondCategoryTable()
    }
        
    var db: OpaquePointer?
    
    
    //MARK: - Open Database
    func openDatabase(user_Id: String) -> OpaquePointer? {
        
        let dbPath = "\(user_Id).sqlite"
        
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
        
        let createTableStatementString = "CREATE TABLE IF NOT EXISTS firstCategory(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT);"
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
        
        let createTableStatementString = "CREATE TABLE IF NOT EXISTS secondCategory(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, firstCategory_Id INTEGER);"
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
    
    
    //MARK: - Update Functions
    //transaction
    func updateTransaction(id: Int,
                           name: String,
                           account_Id: Int,
                           firstCategory_Id: Int,
                           secondCategory_Id: Int,
                           amount: Int,
                           date: String,
                           time: String,
                           payee: String,
                           memo: String) {

        let updateStatementString = "UPDATE deal SET name = ?, account_Id = ?, firstCategory_Id = ?, secondCategory_Id = ?, amount = ?, date = ?, time = ?, payee = ?, memo = ? WHERE id = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(account_Id))
            sqlite3_bind_int(updateStatement, 3, Int32(firstCategory_Id))
            sqlite3_bind_int(updateStatement, 4, Int32(secondCategory_Id))
            sqlite3_bind_int(updateStatement, 5, Int32(amount))
            sqlite3_bind_text(updateStatement, 6, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 7, (time as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 8, (payee as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 9, (memo as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 10, Int32(id))
        
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row")
            } else {
                print("Could not update row")
            }
        } else {
            print("UPDATE statement could not prepare")
        }
        sqlite3_finalize(updateStatement)

    }
    
    
    //account
    func updateAccount(id: Int,
                       name: String) {
        
        let updateStatementString = "UPDATE account SET name = ? WHERE id = ?;"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row")
            } else {
                print("Could not update row")
            }
        } else {
            print("UPDATE statement could not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    //1st category
    func updateFirstCategory (id: Int,
                              name: String) {
        
        let updateStatementString = "UPDATE firstCategory SET name = ? WHERE id = ?;"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row")
            } else {
                print("Could not update row")
            }
        } else {
            print("UPDATE statement could not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    
    //2nd category
    func updateSecondCategory (id: Int,
                               name: String,
                               firstCategory_Id: Int) {
        
        let updateStatementString = "UPDATE secondCategory SET name = ?, firstCategory_Id = ? WHERE id = ?;"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(firstCategory_Id))
            sqlite3_bind_int(updateStatement, 3, Int32(id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row")
            } else {
                print("Could not update row")
            }
        } else {
            print("UPDATE statement could not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    
    
    
    //MARK: - Insert Functions
    //transaction
    func insertTransaction(name: String,
                           account_Id: Int,
                           firstCategory_Id: Int,
                           secondCategory_Id: Int,
                           amount: Int,
                           date: String,
                           time: String,
                           payee: String,
                           memo: String) {
        
        let insertTransactionStatementString = "INSERT INTO deal(name, account_Id, firstCategory_Id, secondCategory_Id, amount, date, time, payee, memo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertTransactionStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertTransactionStatementString, -1, &insertTransactionStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertTransactionStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertTransactionStatement, 2, Int32(account_Id))
            sqlite3_bind_int(insertTransactionStatement, 3, Int32(firstCategory_Id))
            sqlite3_bind_int(insertTransactionStatement, 4, Int32(secondCategory_Id))
            sqlite3_bind_int(insertTransactionStatement, 5, Int32(amount))
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
    func insertAccount(name: String) {
        
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
    func insertFirstCategory(name: String) {

        let insertTransactionStatementString = "INSERT INTO firstCategory(name) VALUES (?);"
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
    
    
    //2ndCategory
    func insertSecondCategory(name: String,
                              firstCategory_Id: Int) {

        let insertTransactionStatementString = "INSERT INTO secondCategory(name, firstCategory_Id) VALUES (?, ?);"
        var insertTransactionStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertTransactionStatementString, -1, &insertTransactionStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertTransactionStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertTransactionStatement, 2, Int32(firstCategory_Id))

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
        let queryStatementString = "SELECT * FROM deal ORDER BY date DESC, time DESC;"
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
                print("\(id) | \(name) | \(account_Id) | \(firstCategory_Id) | \(secondCategory_Id) | \(amount) | \(date) | \(time) | \(payee) | \(memo) ")
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

                fc.append(FirstCategoryEntity(id: Int(id), name: name))
                print("Query Result:")
                print("\(id) | \(name)")
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
                let firstCategory_Id = sqlite3_column_int(queryStatement, 2)

                sc.append(SecondCategoryEntity(id: Int(id), name: name, firstCategory_Id: Int(firstCategory_Id)))
                print("Query Result:")
                print("\(id) | \(name) | \(firstCategory_Id)")
            }
        }else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return sc
    }
    
    
    //read ID from title
    func getAccountIdFromTitle(name: String) -> Int {

        let getAccountIdFromTitleStatementString = "SELECT id FROM account WHERE name = ?;"
        var getAccountIdFromTitleStatement: OpaquePointer?
        var result: Int32 = 0
        if sqlite3_prepare_v2(db, getAccountIdFromTitleStatementString, -1, &getAccountIdFromTitleStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(getAccountIdFromTitleStatement, 1, (name as NSString).utf8String, -1, nil)
            if sqlite3_step(getAccountIdFromTitleStatement) == SQLITE_ROW {
                result = sqlite3_column_int(getAccountIdFromTitleStatement, 0)
            } else {
                print("Could not get id")
            }
        } else {
            print("GET ACCOUNT ID FROM TITLE statement could not prepared")
        }
        sqlite3_finalize(getAccountIdFromTitleStatement)
        return Int(result)
    }
    
    func getFirstCatFromTitle(name: String) -> Int {

        let getFirstCatIdFromTitleStatementString = "SELECT id FROM firstCategory WHERE name = ?;"
        var getFirstCatIdFromTitleStatement: OpaquePointer?
        var result: Int32 = 0
        if sqlite3_prepare_v2(db, getFirstCatIdFromTitleStatementString, -1, &getFirstCatIdFromTitleStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(getFirstCatIdFromTitleStatement, 1, (name as NSString).utf8String, -1, nil)
            if sqlite3_step(getFirstCatIdFromTitleStatement) == SQLITE_ROW {
                result = sqlite3_column_int(getFirstCatIdFromTitleStatement, 0)
            } else {
                print("Could not get id")
            }
        } else {
            print("GET 1ST CATEGORY ID FROM TITLE statement could not prepared")
        }
        sqlite3_finalize(getFirstCatIdFromTitleStatement)
        return Int(result)
    }
    
    func getSecondCatFromTitle(name: String) -> Int {

        let getSecondCatIdFromTitleStatementString = "SELECT id FROM secondCategory WHERE name = ?;"
        var getSecondCatIdFromTitleStatement: OpaquePointer?
        var result: Int32 = 0
        if sqlite3_prepare_v2(db, getSecondCatIdFromTitleStatementString, -1, &getSecondCatIdFromTitleStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(getSecondCatIdFromTitleStatement, 1, (name as NSString).utf8String, -1, nil)
            if sqlite3_step(getSecondCatIdFromTitleStatement) == SQLITE_ROW {
                result = sqlite3_column_int(getSecondCatIdFromTitleStatement, 0)
            } else {
                print("Could not get id")
            }
        } else {
            print("GET 1ST CATEGORY ID FROM TITLE statement could not prepared")
        }
        sqlite3_finalize(getSecondCatIdFromTitleStatement)
        return Int(result)
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
    
    func dropTable() {
        
        let dropTableStatementString = "DROP TABLE deal"
        var dropTAbleStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, dropTableStatementString, -1, &dropTAbleStatement, nil) == SQLITE_OK {
            if sqlite3_step(dropTAbleStatement) == SQLITE_DONE {
                print("Successfully drop table")
            }
        } else {
            print("DROP statement could not be prepared")
        }
        sqlite3_finalize(dropTAbleStatement)
    }
    
    
    //MARK: - Join Expressions
    func loadSubcategory(name: String) -> [String] {
        
        let loadSubcategoryStatementString = "SELECT secondCategory.name FROM secondCategory LEFT OUTER JOIN firstCategory ON firstCategory.id = secondCategory.firstCategory_id WHERE firstCategory.name = ?;"
        var loadSubcategoryStatement : OpaquePointer?
        var subcategory: [String] = []
        if sqlite3_prepare_v2(db, loadSubcategoryStatementString, -1, &loadSubcategoryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(loadSubcategoryStatement, 1, (name as NSString).utf8String, -1, nil)
            
            while sqlite3_step(loadSubcategoryStatement) == SQLITE_ROW {
                let name = String(describing: String(cString: sqlite3_column_text(loadSubcategoryStatement, 0)))

                subcategory.append(name)
                print("Query Result:")
                print("\(name)")
            }
        } else {
            print("JOIN statement could not be prepared")
        }
        sqlite3_finalize(loadSubcategoryStatement)
        return subcategory
    }
 
}
