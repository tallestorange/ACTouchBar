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
    static let controlStripItem = NSCustomTouchBarItem.Identifier("kuwa.controlstrip")
    static let submissionBarExitItem = NSCustomTouchBarItem.Identifier("kuwa.submissionBarExit")
    static let submissionBarItem = NSCustomTouchBarItem.Identifier("kuwa.submissionBar")
    static let submissionItem = NSCustomTouchBarItem.Identifier("kuwa.submission")
    static let statusItem = NSCustomTouchBarItem.Identifier("kuwa.status")
}

struct TouchBarConstants {
    static let identifiers:[NSCustomTouchBarItem.Identifier] = [.settingsItem, .userprofileItem, .userSubmissionInfoItem, .flexibleSpace, .refreshItem, .submissionsItem]
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
        
        let pageParser = PageParser()
        let userProfile = pageParser.getUserProfile(userid: globalVars.shared.userName)!
        ACDatabaseController.shared.saveUserProfileData(user_id: globalVars.shared.userName, profile: userProfile)
        
        let url = URL(string: Constants.problemURL)!
        downloader.getRequest(url: url)
        
        let url2 = URL(string: Constants.infoURL + globalVars.shared.userName)!
        downloader.getRequest(url: url2)
        
        let url3 = URL(string: Constants.resultURL + globalVars.shared.userName)!
        downloader.getRequest(url: url3)
        
    }
    
    @IBAction func pushedSettingButton(sender: NSButton) {
        let settingsWindowController = SettingsWindowController()
        settingsWindowController.showWindow(self)
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
            let button = NSButton.init(image: NSImage.init(named: NSImage.smartBadgeTemplateName)!, target: self, action: #selector(pushedSettingButton(sender:)))
            
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

