//
//  DatabaseController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/06.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa
import Foundation

class DatabaseController: NSObject {
    static let shared = DatabaseController()
    
    override init() {
        super.init()
    }

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
