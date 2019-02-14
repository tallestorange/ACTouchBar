//
//  SubmissionDetailsBarController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/14.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class SubmissionDetailsBarController: NSTouchBar {
    
    var submissionsItems:[NSCustomTouchBarItem]!
    var currentDate:String?
    
    override init() {
        super.init()
        self.defaultItemIdentifiers = [.submissionBarExitItem, .submissionBarItem]
        self.delegate = self
        self.load()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load() {
        let submissions = ACDatabaseController.shared.fetchSubmissionDetailsData(user_id: globalVars.shared.userName)
        self.submissionsItems = self.makeSubmissionItems(submissions: submissions)
    }
    
    func makeSubmissionStateItem(submission: Submission) -> NSCustomTouchBarItem {
        let identifier = "https://atcoder.jp/contests/" + submission.contest_id + "/submissions/" + String(submission.id)
        let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(identifier))
        let button = NSButton.init(title: submission.problem_id, target: self, action: #selector(pushedSubmissionButtonInView(sender:)))
        button.identifier = NSUserInterfaceItemIdentifier(identifier)
        button.bezelColor = self.selectColor(result: submission.result)
        item.view = button
        return item
    }
    
    func makeBackButtonItem() -> NSCustomTouchBarItem {
        let item = NSCustomTouchBarItem(identifier: .submissionBarExitItem)
        let button = NSButton.init(title: globalVars.shared.backButtonTitle, target: self, action: #selector(pushedSubmissionButtonInView(sender:)))
        button.identifier = NSUserInterfaceItemIdentifier("Back")
        button.bezelColor = NSColor.systemBlue
        item.view = button
        return item
    }
    
    func makeDateItem(string: String) -> NSCustomTouchBarItem {
        let item = NSCustomTouchBarItem(identifier: .statusItem)
        let txtField = NSTextField.init(labelWithString: string)
        item.view = txtField
        return item
    }
    
    func makeSubmissionItems(submissions: [Submission]) -> [NSCustomTouchBarItem] {
        var submissionItems:[NSCustomTouchBarItem] = []
        if submissions.isEmpty {
            return []
        }
        for submission in submissions {
            
            let date = epochSecondToDate(epochSecond: submission.epoch_second)
            let dateString = dateToString(date: date)
            
            if (dateString != currentDate) {
                currentDate = dateString
                submissionItems.append(self.makeDateItem(string: dateString))
            }
            
            let item = self.makeSubmissionStateItem(submission: submission)
            submissionItems.append(item)
        }
        return submissionItems
    }
    
    func selectColor(result: String) -> NSColor {
        if result == "AC" {
            return Constants.ACColor
        }
        else {
            return Constants.WAColor
        }
    }
    
    @IBAction func pushedSubmissionButtonInView(sender: NSButton) {
        if sender.identifier == NSUserInterfaceItemIdentifier("Back") {
            minimizeSystemModal(touchBar: self)
        }
        else {
            guard let url = URL(string: sender.identifier!.rawValue) else {return}
            NSWorkspace.shared.open(url)
        }
    }
}

extension SubmissionDetailsBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == .submissionBarExitItem {
            return self.makeBackButtonItem()
        }
        else if identifier == .submissionBarItem {
            let item = NSCustomTouchBarItem(identifier: .submissionBarItem)
            item.view = makeScrollView(stackView: makeStackView(items: self.submissionsItems))
            return item
        }
        return nil
    }
}
