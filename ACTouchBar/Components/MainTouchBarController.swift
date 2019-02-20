//
//  MainTouchBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/11.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

class MainTouchBarController: NSObject {
    // メイン画面
    static let shared = MainTouchBarController()
    
    var touchBar:NSTouchBar!
    var refreshButton:NSButton!
    
    func load() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        if let touchbar = self.touchBar {
            dismissSystemModal(touchBar: touchbar)
        }
        self.touchBar = NSTouchBar()
        self.touchBar.defaultItemIdentifiers = globalVars.shared.identifiers
        self.touchBar.delegate = self
    }
    
    func makeRefreshButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        // 情報更新ボタンアイテムを定義
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        self.refreshButton = NSButton.init(image: NSImage.init(named: NSImage.touchBarRefreshTemplateName)!, target: self, action: #selector(pushedRefreshButton(sender:)))
        self.refreshButton.bezelColor = NSColor.clear
        item.view = self.refreshButton
        return item
    }
    
    func makeSubmissionsButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        // 提出状況移行用のボタンアイテムを定義
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        let button = NSButton(title: globalVars.shared.submissionButtonTitle, target: self, action: #selector(pushedSubmissionButton(sender:)))
        button.bezelColor = NSColor.systemBlue
        item.view = button
        return item
    }
    
    func makeMemoButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        // メモを確認する為のボタンアイテムを定義
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        let button = NSButton.init(image: NSImage.init(named: NSImage.touchBarComposeTemplateName)!, target: self, action: #selector(pushedMemoButton(sender:)))
        item.view = button
        return item
    }
    
    func makeContestButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        // コンテスト一覧を表示する為のボタンアイテムを定義
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        let button = NSButton.init(title: globalVars.shared.contestButtonTitle, target: self, action: #selector(pushedContestButton(sender:)))
        button.bezelColor = Constants.ACColor
        item.view = button
        return item
    }
    
    func makeBackButtonItem(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        // 戻るボタンを表示する為のボタンアイテムを定義
        let item = NSCustomTouchBarItem.init(identifier: identifier)
        let button = NSButton.init(image: NSImage.init(named: NSImage.touchBarGoBackTemplateName)!, target: self, action: #selector(pushedBackButton(sender:)))
        item.view = button
        return item
    }
    
    func reloadAll() {
        // 画面リロード -> 起動時や情報更新時に呼ばれます
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
    
    @IBAction func pushedBackButton(sender: NSButton) {
        dismissSystemModal(touchBar: self.touchBar)
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

extension MainTouchBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {

        switch identifier {
        case .backItem:
            return makeBackButtonItem(identifier: identifier)
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

