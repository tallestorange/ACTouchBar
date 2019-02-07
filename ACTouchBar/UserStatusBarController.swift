//
//  UserStatusBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/06.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

class UserStatusBarController: NSCustomTouchBarItem {
    var statusItems:[NSCustomTouchBarItem] = []
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        self.prepareItems()
    }
    
    func prepareItems() {
        self.statusItems = []
        guard let inputData = DatabaseController.shared.getDataFromFile(filename: "user_info") else {return}
        guard let userInfo = DatabaseController.shared.loadUserInfoJSON(data: inputData) else {return}
        
        self.statusItems.append(makeTextItem(string: "Accepted:", font: GlobalVars.regularFont))
        self.statusItems.append(makeTextItem(string: String(userInfo.accepted_count) + " ", font: GlobalVars.boldFont))
        self.statusItems.append(makeTextItem(string: "RatedPointSum:", font: GlobalVars.regularFont))
        self.statusItems.append(makeTextItem(string: String(Int(userInfo.rated_point_sum)) + "  ", font: GlobalVars.boldFont))
        self.statusItems.append(makeDetailButton())
        
        let item = makeStackView(items: self.statusItems)
        self.view = item
    }
    
    func makeDetailButton() -> NSCustomTouchBarItem {
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier("Detail"))
        let button = NSButton.init(title: "Detail", target: self, action: #selector(pushedButton(sender:)))
        item.view = button
        return item
    }
    
    @IBAction func pushedButton(sender: NSButton) {
        let urlString = "https://kenkoooo.com/atcoder/?user=" + DatabaseController.shared.userName + "&kind=user"
        let url = URL(string: urlString)!
        NSWorkspace.shared.open(url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
