//
//  MemoBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/13.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

class MemoBarController: NSTouchBar {
    override init() {
        super.init()
        self.defaultItemIdentifiers = [.memoItem,.memoContent]
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func pushedBackButton(sender: NSButton) {
        minimizeSystemModal(touchBar: self)
    }
}

extension MemoBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        if identifier == .memoItem {
            let item = NSCustomTouchBarItem.init(identifier: identifier)
            let button = NSButton.init(title: globalVars.shared.backButtonTitle, target: self, action: #selector(pushedBackButton(sender:)))
            item.view = button
            return item
        }
        else if identifier == .memoContent {
            
            let item = NSCustomTouchBarItem(identifier: identifier)
            let textField = NSTextField.init(labelWithString: globalVars.shared.slogan)
            textField.font = Constants.boldFont
            item.view = textField
            
            return item
        }
        
        
        return nil
    }
}
