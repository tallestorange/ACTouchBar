//
//  StartTouchBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/19.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class StartTouchBarController: NSObject {
    // 初期起動時のControl Stripにアイコンが表示された状態のTouchBar
    static let shared = StartTouchBarController()
    
    func load() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        
        let item = NSCustomTouchBarItem.init(identifier: .startItem)
        let button = NSButton.init(title: "AC", target: self, action: #selector(pushedStartButton(sender:)))
        button.bezelColor = Constants.ACColor
        item.view = button
        
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.startItem, true)
    }
    
    @IBAction func pushedStartButton(sender: NSButton) {
        presentSystemModal(touchBar: MainTouchBarController.shared.touchBar, identifier: .controlStripItem, placement: 1)
    }
}
