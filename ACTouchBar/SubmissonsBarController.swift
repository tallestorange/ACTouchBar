//
//  SubmissonsBarController.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/06.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class SubmissonsBarController: NSObject {
    static let shared = SubmissonsBarController()

    var submissionsBar:NSTouchBar!
    var submissionsItems:[NSCustomTouchBarItem]!
    let submissionDB = DatabaseController(userName: "tallestorange")
    var item:NSCustomTouchBarItem!
    var currentDate:String?
    
    override init(){
        super.init()
        
        self.submissionsBar = NSTouchBar()
        self.submissionsBar.defaultItemIdentifiers = [.submissionBarExitItem, .submissionBarItem]
        self.submissionsBar.delegate = self
    }
    
    func prepareDatas() {
        guard let inputData = self.submissionDB.getDataFromFile(filename: "results") else {return}
        guard let submissions = self.submissionDB.loadSubmissionJSON(data: inputData) else {return}
        
        self.submissionsItems = self.makeSubmissionItems(submissions: submissions)
        
        self.item = NSCustomTouchBarItem(identifier: .submissionBarItem)
        self.item.view = self.makeScrollView()
    }
    
    func makeBackButtonItem() -> NSCustomTouchBarItem {
        let item = NSCustomTouchBarItem(identifier: .submissionBarExitItem)
        let button = NSButton.init(title: "Back", target: self, action: #selector(pushedProblemsButton(sender:)))
        button.identifier = NSUserInterfaceItemIdentifier("Back")
        button.bezelColor = NSColor.init(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.95)
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
        var submissionitems:[NSCustomTouchBarItem] = []
        for submission in submissions.reversed()[0..<100]{
            let dateString = self.epochSecondToString(epochSecond: submission.epoch_second)
            
            if (dateString != currentDate) {
                currentDate = dateString
                submissionitems.append(self.makeDateItem(string: dateString))
            }

            let identifier = "https://atcoder.jp/contests/" + submission.contest_id + "/submissions/" + String(submission.id)
            
            let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(identifier))
            let button = NSButton.init(title: submission.problem_id, target: self, action: #selector(pushedProblemsButton(sender:)))
            button.identifier = NSUserInterfaceItemIdentifier(identifier)
            button.bezelColor = self.selectColor(result: submission.result)
            
            item.view = button
            submissionitems.append(item)
        }
        return submissionitems
    }
    
    func selectColor(result: String) -> NSColor {
        if result == "AC" {
            return submissionDB.ACColor
        }
        else {
            return submissionDB.WAColor
        }
    }
    
    func epochSecondToString(epochSecond: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(Double(epochSecond)))
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = " yyyy/MM/dd "
        let dateString = dateFormater.string(from: date)
        return dateString
    }
    
    func makeScrollView() -> NSScrollView {
        let views = self.submissionsItems.compactMap { $0.view }
        let stackView = NSStackView(views: views)
        stackView.spacing = 2
        stackView.orientation = .horizontal
        let scrollView = NSScrollView(frame: CGRect(origin: .zero, size: stackView.fittingSize))
        scrollView.documentView = stackView
        return scrollView
    }
    
    @IBAction func pushedProblemsButton(sender: NSButton) {
        if sender.identifier == NSUserInterfaceItemIdentifier("Back") {
            minimizeSystemModal(touchBar: self.submissionsBar)
        }
        else {
            guard let url = URL(string: sender.identifier!.rawValue) else {return}
            NSWorkspace.shared.open(url)
        }
    }
}

extension SubmissonsBarController: NSTouchBarDelegate {
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
