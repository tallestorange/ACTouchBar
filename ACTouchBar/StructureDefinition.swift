//
//  StructureDefinition.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/07.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

struct Constants {
    static var ACColor = NSColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 0.95)
    static var WAColor = NSColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 0.95)
    static var submissionColor = NSColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.95)
    
    static var resultURL = "https://kenkoooo.com/atcoder/atcoder-api/results?user="
    static var infoURL = "https://kenkoooo.com/atcoder/atcoder-api/v2/user_info?user="
    
    static var regularFont = NSFont.systemFont(ofSize: 15)
    static var boldFont = NSFont.boldSystemFont(ofSize: 21)
    
    static var recentSubmitsQuantity = 50
    static var submissionButtonTitle = "Submissions" //"Recent " + String(Constants.recentSubmitsQuantity) + " Submissions"
    static var backButtonTitle = "Back"
    
    static var grayColor = NSColor.init(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.00)
    static var brownColor = NSColor.init(red: 128/255, green: 64/255, blue: 0/255, alpha: 1.00)
    static var greenColor = NSColor.init(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.00)
    static var cyanColor = NSColor.init(red: 0/255, green: 192/255, blue: 192/255, alpha: 1.00)
    static var blueColor = NSColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.00)
    static var yellowColor = NSColor.init(red: 192/255, green: 192/255, blue: 0/255, alpha: 1.00)
    static var orangeColor = NSColor.init(red: 255/255, green: 128/255, blue: 0/255, alpha: 1.00)
    static var redColor = NSColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.00)
}

struct UserProfile {
    var country:String? = nil
    var birth_year:Int? = nil
    var twitter_id:String? = nil
    var affiliation:String? = nil
    var ranking:String? = nil
    var current_rating:Int = 0
    var highest_rating:Int = 0
    var number_of_times_implemented:Int? = nil
    var current_color:NSColor = NSColor.init(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.00)
    var image:NSImage? = nil
    
    mutating func setColor() {
            if (1 <= self.current_rating && self.current_rating < 400) {
                self.current_color = Constants.grayColor
            }
            else if (400 <= self.current_rating && self.current_rating < 800) {
                self.current_color = Constants.brownColor
            }
            else if (800 <= self.current_rating && self.current_rating < 1200) {
                self.current_color = Constants.greenColor
            }
            else if (1200 <= self.current_rating && self.current_rating < 1600) {
                self.current_color = Constants.cyanColor
            }
            else if (1600 <= self.current_rating && self.current_rating < 2000) {
                self.current_color = Constants.blueColor
            }
            else if (2000 <= self.current_rating && self.current_rating < 2400) {
                self.current_color = Constants.yellowColor
            }
            else if (2400 <= self.current_rating && self.current_rating < 2800) {
                self.current_color = Constants.orangeColor
            }
            else {
                self.current_color = Constants.redColor
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

struct Problem: Codable {
    let id:String
    let contest_id:String
    let title:String
}
