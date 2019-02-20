//
//  SubmissionStatusBarItemController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/06.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

class SubmissionStatusBarItemController: NSCustomTouchBarItem {
//    var statusItems:[NSCustomTouchBarItem] = []
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        self.prepareItems()
    }
    
    func prepareItems() {
        let userInfo = ACDatabaseController.shared.fetchSubmissionInformationData(user_id: globalVars.shared.userName)
        
        // Accept した問題数を表示するアイテム
        let acceptedTextItem = makeTextItem(string: "Accepted:", font: globalVars.shared.regularFont, color: nil)
        let acceptedValueItem = makeTextItem(string: String(userInfo.accepted_count) + " ", font: globalVars.shared.boldFont, color: nil)
        
        // Rated Point Sum を表示するアイテム
        let ratedPointTextItem = makeTextItem(string: "RatedPointSum:", font: globalVars.shared.regularFont, color: nil)
        let ratedPointValueItem = makeTextItem(string: String(Int(userInfo.rated_point_sum)) + "  ", font: globalVars.shared.boldFont, color: nil)
        
        let statusItems = [
            acceptedTextItem,
            acceptedValueItem,
            ratedPointTextItem,
            ratedPointValueItem
        ]
        
        let item = makeStackView(items: statusItems)
        self.view = item
    }
    
    func makeDetailButton() -> NSCustomTouchBarItem {
        // ユーザ詳細に移行するボタン(現在未使用)
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier("Detail"))
        let button = NSButton.init(title: "Detail", target: self, action: #selector(pushedButton(sender:)))
        item.view = button
        return item
    }
    
    @IBAction func pushedButton(sender: NSButton) {
        // ユーザ詳細ボタンを押された場合のアクションを定義(未使用)
        let urlString = "https://kenkoooo.com/atcoder/?user=" + globalVars.shared.userName + "&kind=user"
        let url = URL(string: urlString)!
        NSWorkspace.shared.open(url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
