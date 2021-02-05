//
//  DataTransactionDelegate.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import Foundation

protocol EventDataTransactionDelegate {
        
    func onEditorVCCircleBtnClicked()
        
}

protocol IndexPathPasser {
    
    func onCellEditBtnClicked(editingRowId: Int)
    
}

protocol CreateCategoryVCDelegate {
    
    func onCreateCategoryVCCircleBtnClicked()

}

protocol CreateAccountVCDelegate {
    
    func onCreateAccountVCChangedAccount(accountName: String)
    
}
