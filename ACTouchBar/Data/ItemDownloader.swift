//
//  ItemDownloader.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/10.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Foundation

class ItemDownloader: NSObject {
    static let shared = ItemDownloader()
    
    var userName:String!
    
    func setUserName(userName: String) {
        self.userName = userName
    }
    
    func getRequest(url: URL) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let downloadTask = session.downloadTask(with: url)
        downloadTask.taskDescription = url.absoluteString
        downloadTask.resume()
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
    
    func loadProblemsInfoJSON(data: Data) -> [Problem]? {
        guard let problemsInfo = try? JSONDecoder().decode([Problem].self, from: data) else {return nil}
        return problemsInfo
    }
}

extension ItemDownloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            guard let urlString = downloadTask.taskDescription else {return}
            let data = try Data(contentsOf: location)
            
            if urlString == Constants.problemURL {
                guard let problemsData = self.loadProblemsInfoJSON(data: data) else {return}
                ACDatabaseController.shared.saveProblemsInformationData(problems: problemsData)
            }
            else if urlString.contains(Constants.infoURL) {
                guard let userInfo = self.loadUserInfoJSON(data: data) else {return}
                ACDatabaseController.shared.saveSubmissionInformationData(userInfo: userInfo)
            }
            else if urlString.contains(Constants.resultURL) {
                guard let submissionData = self.loadSubmissionJSON(data: data) else {return}
                ACDatabaseController.shared.saveSubmissionDetailsData(submissions: submissionData)
                DispatchQueue.main.async {
                    TouchBarController.shared.refreshButton.isEnabled = true
                    TouchBarController.shared.load()
                    
                }
            }
            
        }
        catch let error {
            print(error)
        }
    }
}
