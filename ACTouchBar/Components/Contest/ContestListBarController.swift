//
//  ContestListBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/15.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class ContestListBarController: NSTouchBar {
    override init() {
        super.init()
        self.defaultItemIdentifiers = [.contestItem, .contestList]
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeContestItem(contest: CurrentContest) -> NSCustomTouchBarItem {
        // それぞれのコンテストに移動するためのボタンアイテムを作成する
        let identifier = contest.url.absoluteString
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(identifier))
        let button = NSButton.init(title: contest.title, target: self, action: #selector(pushedContestButton(sender:)))
        button.identifier = NSUserInterfaceItemIdentifier(identifier)
        item.view = button
        return item
    }
    
    func makeContestItems() -> [NSCustomTouchBarItem] {
        // 直近のコンテスト分のボタンアイテムを配列として返す
        var contestItems:[NSCustomTouchBarItem] = []
        let pageParser = PageParser()
        let contests = pageParser.getCurrentContests()
        for contest in contests {
            contestItems.append(self.makeContestItem(contest: contest))
        }
        
        return contestItems
    }
    
    @IBAction func pushedBackButton(sender: NSButton) {
        // 現在表示しているTouchBarを最小化する -> 「戻る」操作
        minimizeSystemModal(touchBar: self)
    }
    
    @IBAction func pushedContestButton(sender: NSButton) {
        // コンテスト問題一覧のページへと飛ぶアクションを定義
        guard let urlString = sender.identifier?.rawValue else {return}
        guard let url = URL(string: urlString) else {return}
        
        let nextBar = ContestDetailBarController(contestURL: url)
        presentSystemModal(touchBar: nextBar.touchBar, identifier: .contestDetail, placement: 1)
    }
}

extension ContestListBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        if identifier == .contestItem {
            // 戻るボタン
            let item = NSCustomTouchBarItem.init(identifier: identifier)
            let button = NSButton.init(title: globalVars.shared.backButtonTitle, target: self, action: #selector(pushedBackButton(sender:)))
            button.bezelColor = Constants.ACColor
            item.view = button
            return item
        }
        else if identifier == .contestList {
            // コンテスト一覧
            let item = NSCustomTouchBarItem(identifier: identifier)
            
            // コンテスト一覧をStackViewに変換後、ScrollViewに変換してスクロール可能なViewを作っている
            item.view = makeScrollView(stackView: makeStackView(items: self.makeContestItems()))
            return item
        }
        
        return nil
    }
}
