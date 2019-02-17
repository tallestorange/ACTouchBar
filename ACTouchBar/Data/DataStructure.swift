//
//  DataStructure.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/16.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

struct UserProfile {
    var country:String? = nil
    var birth_year:Int? = nil
    var twitter_id:String? = nil
    var affiliation:String? = nil
    var ranking:String? = nil
    var current_rating:Int = 0
    var highest_rating:Int = 0
    var number_of_times_implemented:Int? = nil
    var current_color:NSColor = NSColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.00)
    var image:NSImage? = nil
    var user_id:String = ""
    
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

struct CurrentContest {
    var url:URL
    var title:String
}
