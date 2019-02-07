//
//  SubmissonsBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/06.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class SubmissonBarController: NSObject {
    static let shared = SubmissonBarController()

    var submissionsBar:NSTouchBar!
    var submissionsItems:[NSCustomTouchBarItem]!
    var item:NSCustomTouchBarItem!
    var currentDate:String?
    
    override init(){
        super.init()
        
        self.submissionsBar = NSTouchBar()
        self.submissionsBar.defaultItemIdentifiers = [.submissionBarExitItem, .submissionBarItem]
        self.submissionsBar.delegate = self
    }
    
    func prepareItems() {
        self.submissionsItems = []

        guard let inputData = DatabaseController.shared.getDataFromFile(filename: "results") else {return}
        guard let submissions = DatabaseController.shared.loadSubmissionJSON(data: inputData) else {return}
        
        self.submissionsItems = self.makeSubmissionItems(submissions: submissions)
        self.item = NSCustomTouchBarItem(identifier: .submissionBarItem)
        self.item.view = makeScrollView(stackView: makeStackView(items: self.submissionsItems))
    }
    
    func makeSubmissionButton() -> NSButton {
        let button = NSButton(title: "Submissions", target: self, action: #selector(pushedSubmissionButton(sender:)))
        button.bezelColor = DatabaseController.shared.submissionColor
        return button
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
        let button = NSButton.init(title: "Back", target: self, action: #selector(pushedSubmissionButtonInView(sender:)))
        button.identifier = NSUserInterfaceItemIdentifier("Back")
        button.bezelColor = DatabaseController.shared.submissionColor
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
        for submission in submissions.reversed()[0..<100]{
            
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
            return DatabaseController.shared.ACColor
        }
        else {
            return DatabaseController.shared.WAColor
        }
    }
    
    @IBAction func pushedSubmissionButtonInView(sender: NSButton) {
        if sender.identifier == NSUserInterfaceItemIdentifier("Back") {
            minimizeSystemModal(touchBar: self.submissionsBar)
        }
        else {
            guard let url = URL(string: sender.identifier!.rawValue) else {return}
            NSWorkspace.shared.open(url)
        }
    }
    
    @IBAction func pushedSubmissionButton(sender: NSButton) {
        presentSystemModal(touchBar: self.submissionsBar, identifier: .submissionItem, placement: 1)
    }
}

extension SubmissonBarController: NSTouchBarDelegate {
    func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == .submissionBarExitItem {
            return self.makeBackButtonItem()
        }
        else if identifier == .submissionBarItem {
            return self.item
        }
        return nil
    }
}
