//
//  DataTransactionDelegate.swift
//  ProjectMoney
//
//  Created by Ethan Son on 2021/01/01.
//

import Foundation

protocol EventDataTransactionDelegate {
    
    func onPlusPopUpVCBtnClicked(segueIndex: Int)
    
    func onEditorVCCircleBtnClicked()
}

protocol indexPathPasser {
    
    func onCellEditBtnClicked(indexPathFromCell: [Int])
    
}
