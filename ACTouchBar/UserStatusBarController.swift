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
        let regularFont = NSFont.systemFont(ofSize: 15)
        let boldFont = NSFont.boldSystemFont(ofSize: 21)
        
        self.statusItems.append(makeTextItem(string: "Accepted:", font: regularFont))
        self.statusItems.append(makeTextItem(string: String(userInfo.accepted_count) + " ", font: boldFont))
        self.statusItems.append(makeTextItem(string: "RatedPointSum:", font: regularFont))
        self.statusItems.append(makeTextItem(string:  String(Int(userInfo.rated_point_sum)), font: boldFont))
        
        let item = makeStackView(items: self.statusItems)
        self.view = item
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
