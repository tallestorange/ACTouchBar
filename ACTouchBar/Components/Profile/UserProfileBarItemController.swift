//
//  UserProfileBarItemController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/07.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

class UserProfileBarItemController: NSCustomTouchBarItem {
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        
        let userProfile = ACDatabaseController.shared.fetchUserProfileData(user_id: globalVars.shared.userName)
        
        // プロフィール画像
        let profileImageItem = self.makeProfileImageItem(image: userProfile.image)
        
        // ユーザ名(ex. chokudai)
        let userNameItem = makeTextItem(string: " " + globalVars.shared.userName + "   ", font: globalVars.shared.boldFont, color: nil)
        
        // レート
        let rateInfoItem = makeTextItem(string: "Rating: ", font: globalVars.shared.regularFont, color: nil)
        let rateValueItem = makeTextItem(string: String(userProfile.current_rating) + " ", font: globalVars.shared.boldFont, color: userProfile.current_color)
        
        self.view = makeStackView(items: [profileImageItem,
                                          userNameItem,
                                          rateInfoItem,
                                          rateValueItem])
    }
    
    func makeProfileImageItem(image: NSImage?) -> NSCustomTouchBarItem {
        // 画像データをTouchBarで表示するサイズ(H,w=30,30)にリサイズしてアイテムとして出力
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(rawValue: "profilePicture"))
        guard let targetImage = image else {return item}
        targetImage.size = NSSize(width: 30, height: 30)
        let imageView = NSImageView(image: targetImage)
        imageView.sizeToFit()
        item.view = imageView
        return item
    }
    
    func loadJpeg() -> Data? {
        let path = Bundle.main.path(forResource: "icon", ofType: "jpg")!
        
        do {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: path))
            return fileData
        }
        catch {
            return nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
