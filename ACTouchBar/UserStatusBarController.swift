//
//  UserStatusBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/06.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

class UserStatusBarController: NSCustomTouchBarItem {
    let DBController = DatabaseController(userName: "tallestorange")
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
