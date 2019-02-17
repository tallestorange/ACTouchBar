//
//  StructureDefinition.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/07.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

class globalVars {
    static let shared = globalVars()
    var userName = "tallestorange"
    var numberOfRecentSubmissions = 100
    
    var submissionButtonTitle = "Submissions"
    var backButtonTitle = "Back"
    var memoButtonTitle = "Memo"
    var contestButtonTitle = "Contests"
    
    var identifiers:[NSCustomTouchBarItem.Identifier] = [.userprofileItem,
                                                         .userSubmissionInfoItem,
                                                         .flexibleSpace,
                                                         .refreshItem,
                                                         .contestItem,
                                                         .memoItem,
                                                         .submissionsItem]
    
    var slogan = "2019/7までに青色！"
    
    var regularFont = NSFont.systemFont(ofSize: 15)
    var boldFont = NSFont.boldSystemFont(ofSize: 21)
}

struct Constants {
    static var AtCoderURL = "https://atcoder.jp"
    static var resultURL = "https://kenkoooo.com/atcoder/atcoder-api/results?user="
    static var infoURL = "https://kenkoooo.com/atcoder/atcoder-api/v2/user_info?user="
    static var problemURL = "https://kenkoooo.com/atcoder/resources/problems.json"
    
    static var ACColor = NSColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 0.95)
    static var WAColor = NSColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 0.95)
    
    static var StandingsACColor = NSColor.init(red: 0/255, green: 170/255, blue: 62/255, alpha: 1.00)
    
    static var whiteColor = NSColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.00)
    static var grayColor = NSColor.init(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.00)
    static var brownColor = NSColor.init(red: 128/255, green: 64/255, blue: 0/255, alpha: 1.00)
    static var greenColor = NSColor.init(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.00)
    static var cyanColor = NSColor.init(red: 0/255, green: 192/255, blue: 192/255, alpha: 1.00)
    static var blueColor = NSColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.00)
    static var yellowColor = NSColor.init(red: 192/255, green: 192/255, blue: 0/255, alpha: 1.00)
    static var orangeColor = NSColor.init(red: 255/255, green: 128/255, blue: 0/255, alpha: 1.00)
    static var redColor = NSColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.00)
}

extension NSTouchBarItem.Identifier {
    static let settingsItem = NSTouchBarItem.Identifier("kuwa.settingsItem")
    static let refreshItem = NSTouchBarItem.Identifier("kuwa.refreshItem")
    static let submissionsItem = NSTouchBarItem.Identifier("kuwa.submissionsItem")
    static let userprofileItem = NSTouchBarItem.Identifier("kuwa.userprofile")
    static let userSubmissionInfoItem = NSCustomTouchBarItem.Identifier("kuwa.usersubmitinfo")
    static let controlStripItem = NSCustomTouchBarItem.Identifier("kuwa.controlstrip")
    static let submissionBarExitItem = NSCustomTouchBarItem.Identifier("kuwa.submissionBarExit")
    static let submissionBarItem = NSCustomTouchBarItem.Identifier("kuwa.submissionBar")
    static let submissionItem = NSCustomTouchBarItem.Identifier("kuwa.submission")
    static let statusItem = NSCustomTouchBarItem.Identifier("kuwa.status")
    static let memoItem = NSCustomTouchBarItem.Identifier("kuwa.memo")
    static let memoContent = NSCustomTouchBarItem.Identifier("kuwa.memocontent")
    static let contestItem = NSCustomTouchBarItem.Identifier("kuwa.contest")
    static let contestList = NSCustomTouchBarItem.Identifier("kuwa.contestList")
    static let contestDetail = NSCustomTouchBarItem.Identifier("kuwa.contestDetail")
    static let contestDetailList = NSCustomTouchBarItem.Identifier("kuwa.contestDetailList")
}

