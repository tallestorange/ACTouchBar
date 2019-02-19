//
//  TouchBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/11.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

class TouchBarController: NSObject {
    static let shared = TouchBarController()
    
    var touchBar:NSTouchBar!
    var refreshButton:NSButton!
    
    override init() {
        super.init()
    }
    
    func load() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
                
        if let touchbar = self.touchBar {
            dismissSystemModal(touchBar: touchbar)
        }
        self.touchBar = NSTouchBar()
        self.touchBar.defaultItemIdentifiers = globalVars.shared.identifiers
        self.touchBar.delegate = self
        presentSystemModal(touchBar: self.touchBar, identifier: .controlStripItem, placement: 1)
    }
    
    func makeRefreshButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        self.refreshButton = NSButton.init(image: NSImage.init(named: NSImage.refreshTemplateName)!, target: self, action: #selector(pushedRefreshButton(sender:)))
        self.refreshButton.bezelColor = NSColor.clear
        item.view = self.refreshButton
        return item
    }
    
    func makeSubmissionsButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        let button = NSButton(title: globalVars.shared.submissionButtonTitle, target: self, action: #selector(pushedSubmissionButton(sender:)))
        button.bezelColor = NSColor.systemBlue
        item.view = button
        return item
    }
    
    func makeMemoButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        let button = NSButton.init(title: globalVars.shared.memoButtonTitle, target: self, action: #selector(pushedMemoButton(sender:)))
        button.bezelColor = Constants.ACColor
        item.view = button
        return item
    }
    
    func makeContestButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        let button = NSButton.init(title: globalVars.shared.contestButtonTitle, target: self, action: #selector(pushedContestButton(sender:)))
        item.view = button
        return item
    }
    
    func reloadAll() {
        self.refreshButton.isEnabled = false
        let pageParser = PageParser()
        
        if let userProfile = pageParser.getUserProfile(userid: globalVars.shared.userName) {
            ACDatabaseController.shared.saveUserProfileData(user_id: globalVars.shared.userName, profile: userProfile)
        }
        
        let url = URL(string: Constants.problemURL)!
        ItemDownloader.shared.getRequest(url: url)
        
        let url2 = URL(string: Constants.infoURL + globalVars.shared.userName)!
        ItemDownloader.shared.getRequest(url: url2)
        
        let url3 = URL(string: Constants.resultURL + globalVars.shared.userName)!
        ItemDownloader.shared.getRequest(url: url3)
    }
    
    @IBAction func pushedRefreshButton(sender: NSButton) {
        self.reloadAll()
    }
    
    @IBAction func pushedMemoButton(sender: NSButton) {
        presentSystemModal(touchBar: MemoBarController(), identifier: .memoItem, placement: 1)
    }
    
    @IBAction func pushedContestButton(sender: NSButton) {
        presentSystemModal(touchBar: ContestListBarController(), identifier: .contestItem, placement: 1)
    }
    
    @IBAction func pushedSubmissionButton(sender: NSButton) {
        presentSystemModal(touchBar: SubmissionDetailsBarController(), identifier: .memoItem, placement: 1)
    }
}

extension TouchBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {

        switch identifier {
        case .userprofileItem:
            return UserProfileBarItemController(identifier: identifier)
        case .userSubmissionInfoItem:
            return SubmissionStatusBarItemController(identifier: identifier)
        case .refreshItem:
            return makeRefreshButtonItem(identifier: identifier)
        case .contestItem:
            return makeContestButtonItem(identifier: identifier)
        case .memoItem:
            return makeMemoButtonItem(identifier: identifier)
        case .submissionsItem:
            return makeSubmissionsButtonItem(identifier: identifier)
        default:
            return nil
        }
    }
}

