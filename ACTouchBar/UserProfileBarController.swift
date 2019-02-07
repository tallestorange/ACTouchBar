//
//  UserProfileBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/07.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

import Foundation

class UserProfileBarController: NSCustomTouchBarItem {
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        
        guard let profileImageItem = self.makeProfileImageItem() else {return}
        let userNameItem = makeTextItem(string: DatabaseController.shared.userName + "   ", font: GlobalVars.boldFont, color: nil)
        let rateInfoItem = makeTextItem(string: "Rating: ", font: GlobalVars.regularFont, color: nil)
        let rateValueItem = makeTextItem(string: String(1136) + " ", font: GlobalVars.rateFont, color: GlobalVars.rateGreenColor)
        
        self.view = makeStackView(items: [profileImageItem, userNameItem, rateInfoItem, rateValueItem])
    }
    
    func makeProfileImageItem() -> NSCustomTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(rawValue: "profilePicture"))
        guard let jpegData = self.loadJpeg() else {return nil}
        guard let image = NSImage(data: jpegData) else {return nil}
        image.size = NSSize(width: 44, height: 44)
        let imageView = NSImageView(image: image)
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
