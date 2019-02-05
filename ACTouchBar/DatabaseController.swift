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

class DatabaseController: NSObject {
    let ACColor = NSColor.init(red: 92/255, green: 184/255, blue: 92/255, alpha: 1.0)
    let WAColor = NSColor.init(red: 240/255, green: 173/255, blue: 78/255, alpha: 1.0)
    let baseURL = "https://kenkoooo.com/atcoder/atcoder-api/results?user="
    var userName:String
    
    init(userName: String) {
        self.userName = userName
    }
    
    func getRequest() throws -> Data? {
        let urlString = self.baseURL + self.userName
        let url = URL(string: urlString)!
        return try Data(contentsOf: url)
    }
    
    func loadJSON() -> [Submission]? {
        guard let data = try? getRequest() else {return nil}
        guard let submissions = try? JSONDecoder().decode([Submission].self, from: data!) else {return nil}
        return submissions
    }
}
