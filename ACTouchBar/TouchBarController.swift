//
//  TouchBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/06.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa

extension NSTouchBarItem.Identifier {
    static let controlStripItem = NSTouchBarItem.Identifier("kuwa.controlStrip")
    static let submissionItem = NSTouchBarItem.Identifier("kuwa.submission")
    static let statusItem = NSTouchBarItem.Identifier("kuwa.status")
}

class TouchBarController: NSObject {
    static let shared = TouchBarController()
    
    let SubmissionBar = SubmissonsBarController.shared
    var touchBar:NSTouchBar!
    
    private override init() {
        super.init()
        
        self.touchBar = NSTouchBar()
        self.touchBar.defaultItemIdentifiers = [.controlStripItem, .statusItem]
        self.touchBar.delegate = self
    }
    
    func setControlStripItem() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        let item = NSCustomTouchBarItem(identifier: .controlStripItem)
        item.view = NSButton(title: "Submission", target: self, action: #selector(pushedButton(sender:)))
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.controlStripItem, true)
        presentSystemModal(touchBar: self.touchBar, identifier: .controlStripItem, placement: 1)
    }
    
    @IBAction func pushedButton(sender: NSButton) {
        presentSystemModal(touchBar: NSTouchBar(), identifier: .submissionItem, placement: 1)
        presentSystemModal(touchBar: SubmissionBar.submissionsBar, identifier: .submissionItem, placement: 1)
    }
}

extension TouchBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == .controlStripItem  {
            let item = NSCustomTouchBarItem(identifier: .controlStripItem)
            item.view = NSButton(title: "Submission", target: self, action: #selector(pushedButton(sender:)))
            return item
        }
        if identifier == .statusItem {
            let item = NSCustomTouchBarItem(identifier: .statusItem)
            item.view = NSButton(title: "hoge", target: self, action: nil)
            return item
        }
        return nil
    }
    
}
