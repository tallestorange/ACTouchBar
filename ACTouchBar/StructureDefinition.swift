//
//  StructureDefinition.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/07.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

struct GlobalVars {
    static var ACColor = NSColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 0.95)
    static var WAColor = NSColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 0.95)
    static var backColor = NSColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.95)
    static var submissionColor = NSColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.95)
    
    static var resultURL = "https://kenkoooo.com/atcoder/atcoder-api/results?user="
    static var infoURL = "https://kenkoooo.com/atcoder/atcoder-api/v2/user_info?user="
    
    static var regularFont = NSFont.systemFont(ofSize: 15)
    static var boldFont = NSFont.boldSystemFont(ofSize: 21)
}

struct Submission: Codable {
    let execution_time:Int?
    let point:Float
    let result:String
    let problem_id:String
    let user_id:String
    let epoch_second:Int
    let contest_id:String
    let id:Int
    let language:String
    let length:Int
}

struct UserInfo: Codable {
    let accepted_count_rank:Int
    let rated_point_sum_rank:Int
    let rated_point_sum:Float
    let user_id:String
    let accepted_count:Int
}
