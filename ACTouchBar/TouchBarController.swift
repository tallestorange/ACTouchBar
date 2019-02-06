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
    
    let DBController = DatabaseController(userName: "tallestorange")
    let SubmissionBar = SubmissonsBarController.shared
    var touchBar:NSTouchBar!
    var userInfo:UserInfo!
    
    private override init() {
        super.init()
        
        self.touchBar = NSTouchBar()
        presentSystemModal(touchBar: self.touchBar, identifier: .controlStripItem, placement: 1)
        self.touchBar.defaultItemIdentifiers = [.statusItem, .controlStripItem]
        self.touchBar.delegate = self
        
        guard let inputData = DBController.getDataFromFile(filename: "user_info") else {return}
        guard let userInfo = DBController.loadUserInfoJSON(data: inputData) else {return}
        self.userInfo = userInfo
    }
    
    func setControlStripItem() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
    }
    
    @IBAction func pushedButton(sender: NSButton) {
        presentSystemModal(touchBar: SubmissionBar.submissionsBar, identifier: .submissionItem, placement: 1)
    }
}

extension TouchBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == .controlStripItem  {
            let item = NSCustomTouchBarItem(identifier: .controlStripItem)
            let button = NSButton(title: "Submissions", target: self, action: #selector(pushedButton(sender:)))
            item.view = button
            return item
        }
        if identifier == .statusItem {
            let item = NSCustomTouchBarItem(identifier: .statusItem)
            let txtField = NSTextField.init(labelWithString: "RatedPointSum: " + String(Int(self.userInfo.rated_point_sum)))
            item.view = txtField
            return item
        }
        return nil
    }
    
}

