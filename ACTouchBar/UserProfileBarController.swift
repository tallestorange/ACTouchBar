//
//  UserProfileBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/07.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

class UserProfileBarController: NSCustomTouchBarItem {
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        
        let pageParser = PageParser()
        let userProfile = pageParser.getUserProfile(userid: DatabaseController.shared.userName)!
        
        let profileImageItem = self.makeProfileImageItem(image: userProfile.image)
        let userNameItem = makeTextItem(string: DatabaseController.shared.userName + "   ", font: GlobalVars.boldFont, color: nil)
        let rateInfoItem = makeTextItem(string: "Rating: ", font: GlobalVars.regularFont, color: nil)
        let rateValueItem = makeTextItem(string: String(userProfile.current_rating!) + " ", font: GlobalVars.boldFont, color: userProfile.current_color)
        
        self.view = makeStackView(items: [profileImageItem, userNameItem, rateInfoItem, rateValueItem])
    }
    
    func makeProfileImageItem(image: NSImage?) -> NSCustomTouchBarItem {
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(rawValue: "profilePicture"))
        guard let targetImage = image else {return item}
        targetImage.size = NSSize(width: 44, height: 44)
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
