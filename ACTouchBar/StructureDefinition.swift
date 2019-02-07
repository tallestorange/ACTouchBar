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
    
    static var rateGreenColor = NSColor.init(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.00)
    
    static var resultURL = "https://kenkoooo.com/atcoder/atcoder-api/results?user="
    static var infoURL = "https://kenkoooo.com/atcoder/atcoder-api/v2/user_info?user="
    
    static var regularFont = NSFont.systemFont(ofSize: 15)
    static var boldFont = NSFont.boldSystemFont(ofSize: 21)
    static var rateFont = NSFont.init(name: "SquadaOne-Regular", size: 28)!
}

struct UserProfile {
    var country:String? = nil
    var birth_year:Int? = nil
    var twitter_id:String? = nil
    var affiliation:String? = nil
    var ranking:String? = nil
    var current_rating:Int? = nil
    var highest_rating:Int? = nil
    var number_of_times_implemented:Int? = nil
    var current_color:NSColor = NSColor.init(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.00)
    var image:NSImage? = nil
    
    mutating func setColor() {
        if let rate = self.current_rating {
            if (1 <= rate && rate < 400) {
                self.current_color = NSColor.init(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.00)
            }
            else if (400 <= rate && rate < 800) {
                self.current_color = NSColor.init(red: 128/255, green: 64/255, blue: 0/255, alpha: 1.00)
            }
            else if (800 <= rate && rate < 1200) {
                self.current_color = NSColor.init(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.00)
            }
            else if (1200 <= rate && rate < 1600) {
                self.current_color = NSColor.init(red: 0/255, green: 192/255, blue: 192/255, alpha: 1.00)
            }
            else if (1600 <= rate && rate < 2000) {
                self.current_color = NSColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.00)
            }
            else if (2000 <= rate && rate < 2400) {
                self.current_color = NSColor.init(red: 192/255, green: 192/255, blue: 0/255, alpha: 1.00)
            }
            else if (2400 <= rate && rate < 2800) {
                self.current_color = NSColor.init(red: 255/255, green: 128/255, blue: 0/255, alpha: 1.00)
            }
            else {
                self.current_color = NSColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.00)
            }
        }
    }
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
