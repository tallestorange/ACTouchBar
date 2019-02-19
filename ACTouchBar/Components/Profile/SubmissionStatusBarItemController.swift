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
        
        let statusItems = [
            makeTextItem(string: "Accepted:", font: globalVars.shared.regularFont, color: nil),
            makeTextItem(string: String(userInfo.accepted_count) + " ", font: globalVars.shared.boldFont, color: nil),
            makeTextItem(string: "RatedPointSum:", font: globalVars.shared.regularFont, color: nil),
            makeTextItem(string: String(Int(userInfo.rated_point_sum)) + "  ", font: globalVars.shared.boldFont, color: nil)
        ]
        
        let item = makeStackView(items: statusItems)
        self.view = item
    }
    
    func makeDetailButton() -> NSCustomTouchBarItem {
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier("Detail"))
        let button = NSButton.init(title: "Detail", target: self, action: #selector(pushedButton(sender:)))
        item.view = button
        return item
    }
    
    @IBAction func pushedButton(sender: NSButton) {
        let urlString = "https://kenkoooo.com/atcoder/?user=" + globalVars.shared.userName + "&kind=user"
        let url = URL(string: urlString)!
        NSWorkspace.shared.open(url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
