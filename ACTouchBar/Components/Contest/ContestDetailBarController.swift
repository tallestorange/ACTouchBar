//
//  ContestDetailBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/18.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class ContestDetailBarController: NSObject {
    
    var contestURL:URL!
    var touchBar:NSTouchBar!
    var timer:Timer?
    
    init(contestURL: URL) {
        super.init()
        
        self.contestURL = contestURL
        self.load()
        
        // 提出状況自動更新タイマーを設定
        self.timer = Timer.scheduledTimer(withTimeInterval: globalVars.shared.autoRefreshInterval, repeats: true) {_ in
            self.load()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load() {
        if let touchbar = self.touchBar {
            dismissSystemModal(touchBar: touchbar)
        }
        self.touchBar = NSTouchBar()
        
        self.touchBar.defaultItemIdentifiers = [.contestDetail, .contestDetailList]
        self.touchBar.delegate = self
        presentSystemModal(touchBar: self.touchBar, identifier: .controlStripItem, placement: 1)
    }
    
    func makeProblemButton(title: String, problemid: String, color: NSColor) -> NSCustomTouchBarItem {
        
        // それぞれの問題に遷移するためのボタンを作成
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(problemid))
        
        guard let url = self.contestURL else {return item}
        
        // urlString -> 各問題へのURLを保持
        var urlString = url.absoluteString
        if let range = urlString.range(of: "standings/json") {
            urlString.replaceSubrange(range, with: "tasks/" + problemid)
        }
        
        let button = NSButton.init(title: title, target: self, action: #selector(pushedProblemButton(sender:)))
        
        // ボタンの識別子に問題URLを指定 -> ボタン押下後の処理を簡単にするため
        button.identifier = NSUserInterfaceItemIdentifier(urlString)
        
        button.font = globalVars.shared.boldFont
        button.bezelColor = color
        
        item.view = button
        return item
    }
    
    func makeStandingsItems(standingsData: [String:StandingsInfo]) -> [NSCustomTouchBarItem] {
        // 提出状況のボタンアイテムを作成
        var standingsItems:[NSCustomTouchBarItem] = []
        let keys = standingsData.keys.sorted(by: {$0 < $1})
        for key in keys {
            guard let item = standingsData[key] else {continue}
            
            // 初期問題色はNot Submitted状態の色
            var problemNameColor = NSColor.init(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.00)
            
            // UserSubmitStatus: -1==WA 1==AC 0==Not Submitted
            if item.UserSubmitStatus == -1 {
                problemNameColor = Constants.WAColor
            }
            else if item.UserSubmitStatus == 1 {
                problemNameColor = Constants.ACColor
            }
            
            // 問題に遷移するためのボタンアイテム
            let problemNameItem = self.makeProblemButton(title: key, problemid: item.TaskScreenName, color: problemNameColor)
            
            // 提出状況表示アイテム
            let collectContestantsItem = makeTextItem(string: " " + String(item.CollectContestants), font: globalVars.shared.regularFont, color: Constants.StandingsACColor)
            let separatorItem = makeTextItem(string: "/", font: globalVars.shared.regularFont, color: nil)
            let totalContestantsItem = makeTextItem(string: String(item.TotalContestants), font: globalVars.shared.regularFont, color: nil)
            
            // 余白テキストアイテム
            let separatorItem2 = makeTextItem(string: "     ", font: globalVars.shared.regularFont, color: nil)
            
            standingsItems += [problemNameItem,
                               collectContestantsItem,
                               separatorItem,
                               totalContestantsItem,
                               separatorItem2]
        }
        return standingsItems
    }
    
    
    func getStandingsInfo(url: URL) -> [String:StandingsInfo] {
        var taskDict:[String:String] = [:]
        var standingsInfo:[String:StandingsInfo] = [:]
        
        do {
            let data = try Data(contentsOf: url)
            guard let standings = ItemDownloader.shared.loadStandingsInfoJSON(data: data) else {return [:]}
            
            // Problem_id と 表示名の対応付けを行う
            for task in standings.TaskInfo {
                taskDict[task.TaskScreenName] = task.Assignment

                var item = StandingsInfo()
                item.TaskScreenName = task.TaskScreenName
                standingsInfo[task.Assignment] = item
            }
            
            // 公式JSを参考
            for contestant in standings.StandingsData {
                for (problemName, result) in contestant.TaskResults {
                    let name = taskDict[problemName]!
                    
                    if contestant.UserScreenName == globalVars.shared.userName {
                        // UserSubmitStatus: -1==WA 1==AC 0==Not Submitted
                        standingsInfo[name]?.UserSubmitStatus = -1
                    }
                    standingsInfo[name]?.TotalContestants += 1
                    
                    // Status==1 の時はACをした場合(らしい)
                    if result.Status == 1 {
                        if contestant.UserScreenName == globalVars.shared.userName {
                            standingsInfo[name]?.UserSubmitStatus = 1
                        }
                        standingsInfo[name]?.CollectContestants += 1
                    }
                }
            }
            
            return standingsInfo
        }
        catch {
            return [:]
        }
    }
    
    @IBAction func pushedBackButton(sender: NSButton) {
        // 戻るボタンを押した際には自動更新タイマーを切る
        self.timer?.invalidate()
        // TouchBarの最小化
        minimizeSystemModal(touchBar: self.touchBar)
    }
    
    @IBAction func pushedProblemButton(sender: NSButton) {
        // 各問題のページへと飛ぶアクションを定義
        guard let url = URL(string: sender.identifier!.rawValue) else {return}
        NSWorkspace.shared.open(url)
    }
}

extension ContestDetailBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == .contestDetail {
            // 戻るボタン
            let item = NSCustomTouchBarItem.init(identifier: identifier)
            let button = NSButton.init(title: globalVars.shared.backButtonTitle, target: self, action: #selector(pushedBackButton(sender:)))
            item.view = button
            return item
        }
        
        if identifier == .contestDetailList {
            // コンテストの提出状況
            let item = NSCustomTouchBarItem(identifier: identifier)
            let standingsInfo = self.getStandingsInfo(url: self.contestURL)
            item.view = makeScrollView(stackView: makeStackView(items: self.makeStandingsItems(standingsData: standingsInfo)))
            return item
        }
        
        return nil
    }
}
