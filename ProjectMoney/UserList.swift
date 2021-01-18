//
//  UserList.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/19.
//

import Foundation
import SQLite3

class UserListDatabaseManager {

    init() {
        
        db = openDatabase()
        createUserTable()
        
    }

    
    let dbPath: String = "UserList.sqlite"
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

    func createUserTable() {
        
        let createTableStatementString = "CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY AUTOINCREMENT, user_ID TEXT, user_Password TEXT, name TEXT, emailAdress TEXT);"
        var createTableStatement : OpaquePointer?
        
        if sqlite3_prepare_v2(db, createTableStatementString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("user table created")
            } else {
                print("user table could not be created")
            }
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        sqlite3_finalize(createTableStatement)
    }

    
    
    func insertUser(user_ID: String,
                    user_Password: String,
                    name: String,
                    emailAdress: String) {
        
        let signInUserStatementString = "INSERT INTO user(user_ID, user_Password, name, emailAdress) VALUES (?, ?, ?, ?);"
        var signInUserStatment: OpaquePointer?
        if sqlite3_prepare_v2(db, signInUserStatementString, -1, &signInUserStatment, nil) == SQLITE_OK {
            sqlite3_bind_text(signInUserStatment, 1, (user_ID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(signInUserStatment, 2, (user_Password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(signInUserStatment, 3, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(signInUserStatment, 4, (emailAdress as NSString).utf8String, -1, nil)

            
            if sqlite3_step(signInUserStatment) == SQLITE_DONE {
                print("Successfully Inserted row")
            } else {
                print("Could not insert row")
            }
        } else {
            print("INSERT statement could not prepare")
        }
        sqlite3_finalize(signInUserStatment)
    }
    
    
    
    func readUser() -> [UserEntity] {
        
        let queryStatementString = "SELECT * FROM user;"
        var queryStatement: OpaquePointer?
        var userInfo : [UserEntity] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let user_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let user_password = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let emailAdress = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))

                userInfo.append(UserEntity(user_ID: user_id, user_Password: user_password, name: name, emailAdress: emailAdress))
                print("Query Result:")
                print("\(id) | \(user_id) | \(user_password) | \(name) | \(emailAdress)")
            }
        }else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return userInfo
    }

    
    
    func changePassword(id: String,
                        password: String) {
 
         let updateStatementString = "UPDATE user SET password = ? WHERE id = ?;"
         var updateStatement: OpaquePointer?
         if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
             sqlite3_bind_text(updateStatement, 1, (password as NSString).utf8String, -1, nil)
             sqlite3_bind_text(updateStatement, 2, (id as NSString).utf8String, -1, nil)


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
    
    func deleteUser(id: String,
                    password: String) {
        
        let deleteStatementString = "DELETE FROM user WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row by id")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
 
    }
    
    func dropUserListTable() {
        
        let dropTableStatementString = "DROP TABLE user"
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
}

