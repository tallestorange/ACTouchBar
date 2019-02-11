//
//  MainTouchBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/11.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

extension NSTouchBarItem.Identifier {
    static let settingsItem = NSTouchBarItem.Identifier("kuwa.settingsItem")
    static let refreshItem = NSTouchBarItem.Identifier("kuwa.refreshItem")
    static let submissionsItem = NSTouchBarItem.Identifier("kuwa.submissionsItem")
    static let userprofileItem = NSTouchBarItem.Identifier("kuwa.userprofile")
    static let userSubmissionInfoItem = NSCustomTouchBarItem.Identifier("kuwa.usersubmitinfo")
}

struct TouchBarConstants {
    static let identifiers:[NSCustomTouchBarItem.Identifier] = [.settingsItem, .userprofileItem, .userSubmissionInfoItem, .flexibleSpace, .refreshItem, .submissionsItem]
    static let userName = "tallestorange"
}

class MainTouchBarController: NSObject {
    static let shared = MainTouchBarController()
    
    var touchBar:NSTouchBar!
    var refreshButton:NSButton!
    
    override init() {
        super.init()
        self.refreshButton = NSButton.init(image: NSImage.init(named: NSImage.refreshTemplateName)!, target: self, action: #selector(pushedRefreshButton(sender:)))
    }
    
    func load() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        if let touchbar = self.touchBar {
            dismissSystemModal(touchBar: touchbar)
        }
        self.touchBar = NSTouchBar()
        self.touchBar.defaultItemIdentifiers = TouchBarConstants.identifiers
        self.touchBar.delegate = self
        presentSystemModal(touchBar: self.touchBar, identifier: .controlStripItem, placement: 1)
    }
    
    @IBAction func pushedRefreshButton(sender: NSButton) {
        sender.isEnabled = false
        let downloader = ItemDownloader()
        
        let url = URL(string: "https://kenkoooo.com/atcoder/resources/problems.json")!
        downloader.getRequest(url: url)
        
        let url2 = URL(string: "https://kenkoooo.com/atcoder/atcoder-api/results?user=tallestorange")!
        downloader.getRequest(url: url2)
        
    }
    
    @IBAction func pushedSubmissionButton(sender: NSButton) {
        
    }
}

extension MainTouchBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == .refreshItem {
            let item = NSCustomTouchBarItem.init(identifier: identifier)
            item.view = self.refreshButton
            print(item)
            return item
        }
        else if identifier == .settingsItem {
            let item = NSCustomTouchBarItem.init(identifier: identifier)
            let button = NSButton.init(image: NSImage.init(named: NSImage.smartBadgeTemplateName)!, target: nil, action: nil)
            
            item.view = button
            return item
        }
        else if identifier == .submissionsItem {
            let item = NSCustomTouchBarItem.init(identifier: identifier)
            item.view = SubmissonDetailsBarController.shared.makeSubmissionButton()
            return item
        }
        else if identifier == .userprofileItem {
            return UserProfileBarController(identifier: identifier)
        }
        else if identifier == .userSubmissionInfoItem {
            return SubmissionStatusBarController(identifier: identifier)
        }
        
        return nil
    }
}

