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
    static let submissionBarItem = NSTouchBarItem.Identifier("kuwa.submissionbar")
    static let submissionBarExitItem = NSTouchBarItem.Identifier("kuwa.submissionExitbar")
}

class TouchBarController: NSObject {
    static let shared = TouchBarController()
    
    let SubmissionBar = SubmissonsBarController.shared
    let identifiers:[NSTouchBarItem.Identifier] = [.controlStripItem]
    var items:[NSTouchBarItem.Identifier:NSCustomTouchBarItem] = [:]
    var touchBar:NSTouchBar!
    
    private override init() {
        super.init()
        
        self.touchBar = NSTouchBar()
        self.touchBar.defaultItemIdentifiers = self.identifiers
        self.makeItems()
        self.touchBar.delegate = self
    }
    
    func makeItems() {
        for identifier in self.identifiers {
            self.items[identifier] = NSCustomTouchBarItem(identifier: identifier)
            
            if identifier == .controlStripItem  {
                let button = NSButton(title: "Submissions", target: self, action: #selector(pushedButton(sender:)))
                button.bezelColor = NSColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.95)
                self.items[identifier]?.view = button
            }

        }
    }
    
    func setControlStripItem() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        presentSystemModal(touchBar: self.touchBar, identifier: .controlStripItem, placement: 1)
    }
    
    @IBAction func pushedButton(sender: NSButton) {
        presentSystemModal(touchBar: SubmissionBar.submissionsBar, identifier: .submissionItem, placement: 1)
    }
}

extension TouchBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        return self.items[identifier]
    }
    
}

