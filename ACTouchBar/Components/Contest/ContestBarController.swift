//
//  ContestBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/15.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class ContestBarController: NSTouchBar {
    override init() {
        super.init()
        self.defaultItemIdentifiers = [.contestItem]
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func pushedBackButton(sender: NSButton) {
        minimizeSystemModal(touchBar: self)
    }
}

extension ContestBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        if identifier == .contestItem {
            let item = NSCustomTouchBarItem.init(identifier: identifier)
            let button = NSButton.init(title: globalVars.shared.backButtonTitle, target: self, action: #selector(pushedBackButton(sender:)))
            item.view = button
            return item
        }
        
        return nil
    }
}
