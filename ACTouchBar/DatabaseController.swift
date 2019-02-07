//
//  DatabaseController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/06.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa
import Foundation

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

class DatabaseController: NSObject {
    static let shared = DatabaseController()
    
    override init() {
        super.init()
    }
    
    let ACColor = NSColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 0.95)
    let WAColor = NSColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 0.95)
    let backColor = NSColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.95)
    let submissionColor = NSColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.95)
    
    let resultURL = "https://kenkoooo.com/atcoder/atcoder-api/results?user="
    let infoURL = "https://kenkoooo.com/atcoder/atcoder-api/v2/user_info?user="
    var userName:String!
    
    func setUserName(userName: String) {
        self.userName = userName
    }
    
    func getAPIRequest(urlString: String) -> Data? {
        let url = URL(string: urlString)!
        
        do {
            return try Data(contentsOf: url)
        }
        catch {
            return nil
        }
    }
    
    func getDataFromFile(filename: String) -> Data? {
        let path = Bundle.main.path(forResource: filename, ofType: "json")!
        
        do {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: path))
            return fileData
        }
        catch {
            return nil
        }
    }
    
    func loadSubmissionJSON(data: Data) -> [Submission]? {
        guard let submissions = try? JSONDecoder().decode([Submission].self, from: data) else {return nil}
        return submissions
    }
    
    func loadUserInfoJSON(data: Data) -> UserInfo? {
        guard let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) else {return nil}
        return userInfo
    }
}
