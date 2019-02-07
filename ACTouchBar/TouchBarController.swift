//
//  TouchBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/06.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

extension NSTouchBarItem.Identifier {
    static let controlStripItem = NSTouchBarItem.Identifier("kuwa.controlStrip")
    static let submissionItem = NSTouchBarItem.Identifier("kuwa.submission")
    static let statusItem = NSTouchBarItem.Identifier("kuwa.status")
    static let submissionBarItem = NSTouchBarItem.Identifier("kuwa.submissionbar")
    static let submissionBarExitItem = NSTouchBarItem.Identifier("kuwa.submissionExitbar")
    static let userProfile = NSTouchBarItem.Identifier("kuwa.userProfile")
}

class TouchBarController: NSObject {
    static let shared = TouchBarController()
    
    let identifiers:[NSTouchBarItem.Identifier] = [.userProfile, .statusItem, .flexibleSpace, .controlStripItem]
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
                self.items[identifier]?.view = SubmissonDetailsBarController.shared.makeSubmissionButton()
            }
            else if identifier == .statusItem {
                self.items[identifier] = SubmissionStatusBarController(identifier: .statusItem)
            }
            else if identifier == .userProfile {
                self.items[identifier] = UserProfileBarController(identifier: .userProfile)
            }
        }
    }
    
    func setControlStripItem() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        presentSystemModal(touchBar: self.touchBar, identifier: .controlStripItem, placement: 1)
    }
}

extension TouchBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        return self.items[identifier]
    }
}

