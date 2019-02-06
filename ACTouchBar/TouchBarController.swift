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
}

class TouchBarController: NSObject, NSTouchBarDelegate {
    static let shared = TouchBarController()
    var submissionsBar = NSTouchBar()
    
    private override init() {
        super.init()
        self.submissionsBar.defaultItemIdentifiers = [.submissionItem]
        self.submissionsBar.delegate = self
    }
    
    func setControlStripItem() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        
        let item = NSCustomTouchBarItem(identifier: .controlStripItem)
        item.view = NSButton(title: "Submission", target: self, action: #selector(pushedButton(sender:)))
        
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.controlStripItem, true)
    }
    
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == .controlStripItem  {
            let item = NSCustomTouchBarItem(identifier: .controlStripItem)
            item.view = NSButton(title: "Submission", target: self, action: #selector(pushedButton(sender:)))
            return item
        }
        else if identifier == .submissionItem {
            let item = SubmissionItemsGenerator(identifier: .submissionItem)
            return item
        }
        return nil
    }
    
    @IBAction func pushedButton(sender: NSButton) {
        if #available(OSX 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(self.submissionsBar, systemTrayItemIdentifier: .submissionItem)
        }
        else {
            NSTouchBar.presentSystemModalFunctionBar(self.submissionsBar, systemTrayItemIdentifier: .submissionItem)
        }
    }
}
