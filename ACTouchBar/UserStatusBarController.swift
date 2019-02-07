//
//  UserStatusBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/06.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

class UserStatusBarController: NSCustomTouchBarItem {
    var statusItems:[NSCustomTouchBarItem] = []
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        self.makeItems()
        let item = makeStackView(items: self.statusItems)
        self.view = item
    }
    
    func makeItems() {
        for i in 0...10 {
            let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(rawValue: String(i)))
            item.view = NSButton.init(title: String(i), target: nil, action: nil)
            self.statusItems.append(item)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
