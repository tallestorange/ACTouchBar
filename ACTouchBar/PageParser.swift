//
//  PageParser.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/07.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Kanna

class PageParser {
    
    func getHTMLDocument(url: String) throws -> HTMLDocument? {
        guard let url = URL(string: url) else {return nil}
        return try HTML(url: url, encoding: String.Encoding.utf8)
    }
    
    func getRequest(urlString: String) -> Data? {
        let url = URL(string: urlString)!
        
        do {
            return try Data(contentsOf: url)
        }
        catch {
            return nil
        }
    }
    
    func getUserProfile(userid: String) -> UserProfile? {
        var userProfile = UserProfile()
        
        do {
            let doc = try getHTMLDocument(url: "https://atcoder.jp/users/" + userid)
            
            guard let avatarNodes = doc?.css("img[class='avatar']") else {return nil}
            for node in avatarNodes {
                if let urlString = node["src"] {
                    guard let data = getRequest(urlString: urlString) else {break}
                    guard let image = NSImage.init(data: data) else {break}
                    userProfile.image = image
                    break
                }
            }
            
            guard let profileNodes = doc?.css("th[class='no-break']") else {return nil}
            for node in profileNodes {
                if let key = node.text, let value = node.nextSibling?.text {
                    let trimmedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    switch trimmedKey {
                    case "国籍":
                        userProfile.country = trimmedValue
                    case "誕生年":
                        if let intValue = Int(trimmedValue) {
                            userProfile.birth_year = intValue
                        }
                    case "Twitter ID":
                        userProfile.twitter_id = trimmedValue
                    case "所属":
                        userProfile.affiliation = trimmedValue
                    case "順位":
                        userProfile.ranking = trimmedValue
                    case "Rating":
                        if let intValue = Int(trimmedValue) {
                            userProfile.current_rating = intValue
                        }
                    case "Rating最高値":
                        if let intValue = Int(trimmedValue) {
                            userProfile.highest_rating = intValue
                        }
                    case "コンテスト参加回数":
                        if let intValue = Int(trimmedValue) {
                            userProfile.number_of_times_implemented = intValue
                        }
                    default:
                        break
                    }
                }
                
            }
            userProfile.setColor()
            return userProfile
        }
        catch let error {
            print(error)
            return nil
        }
    }
}
