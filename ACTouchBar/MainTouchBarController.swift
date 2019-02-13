//
//  MainTouchBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/11.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

class MainTouchBarController: NSObject {
    static let shared = MainTouchBarController()
    
    var touchBar:NSTouchBar!
    var refreshButton:NSButton!
    let submissionDetaisBar = SubmissionDetailsBarController()
    
    override init() {
        super.init()
        self.refreshButton = NSButton.init(image: NSImage.init(named: NSImage.refreshTemplateName)!, target: self, action: #selector(pushedRefreshButton(sender:)))
    }
    
    func load() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        
        self.submissionDetaisBar.load()
        
        if let touchbar = self.touchBar {
            dismissSystemModal(touchBar: touchbar)
        }
        self.touchBar = NSTouchBar()
        self.touchBar.defaultItemIdentifiers = globalVars.shared.identifiers
        self.touchBar.delegate = self
        presentSystemModal(touchBar: self.touchBar, identifier: .controlStripItem, placement: 1)
    }
    
    @IBAction func pushedRefreshButton(sender: NSButton) {
        sender.isEnabled = false
                
        let downloader = ItemDownloader()
        
        let pageParser = PageParser()
        if let userProfile = pageParser.getUserProfile(userid: globalVars.shared.userName) {
            ACDatabaseController.shared.saveUserProfileData(user_id: globalVars.shared.userName, profile: userProfile)
        }
        
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
    
    @IBAction func pushedMemoButton(sender: NSButton) {
        presentSystemModal(touchBar: MemoBarController(), identifier: .memoItem, placement: 1)
    }
    
    @IBAction func pushedSubmissionButton(sender: NSButton) {
        presentSystemModal(touchBar: submissionDetaisBar, identifier: .memoItem, placement: 1)
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
            
            let button = NSButton(title: globalVars.shared.submissionButtonTitle, target: self, action: #selector(pushedSubmissionButton(sender:)))
            button.bezelColor = NSColor.systemBlue
            item.view = button
            
            return item
        }
        else if identifier == .userprofileItem {
            return UserProfileBarItemController(identifier: identifier)
        }
        else if identifier == .userSubmissionInfoItem {
            return SubmissionStatusBarItemController(identifier: identifier)
        }
        else if identifier == .memoItem {
            let item = NSCustomTouchBarItem.init(identifier: identifier)
            let button = NSButton.init(title: globalVars.shared.memoButtonTitle, target: self, action: #selector(pushedMemoButton(sender:)))
            button.bezelColor = Constants.ACColor
            item.view = button
            return item
        }
        
        return nil
    }
}

