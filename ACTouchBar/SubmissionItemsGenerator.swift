//
//  SubmissionItemsGenerator.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/06.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class SubmissionItemsGenerator: NSCustomTouchBarItem {
    let submissionDB = DatabaseController(userName: "tallestorange")
    var submissions:[Submission]!
    var submissionItems:[NSCustomTouchBarItem]!
    
    override init(identifier: NSTouchBarItem.Identifier) {
        super.init(identifier: identifier)
        
//        guard let inputData = self.submissionDB.getAPIRequest() else {return}
        guard let inputData = self.submissionDB.getDataFromFile(filename: "results") else {return}
        
        self.submissions = self.submissionDB.loadJSON(data: inputData)
        self.submissionItems = self.makeSubmissionItems()
        self.view = self.makeScrollView()
    }
    
    func makeSubmissionItems() -> [NSCustomTouchBarItem] {
        var submissionitems:[NSCustomTouchBarItem] = []
        for submission in self.submissions.reversed()[0..<100]{
            let identifier = "https://atcoder.jp/contests/" + submission.contest_id + "/submissions/" + String(submission.id)
            
            let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(identifier))
            let button = NSButton.init(title: submission.problem_id, target: self, action: #selector(pushedProblemsButton(sender:)))
            button.identifier = NSUserInterfaceItemIdentifier(identifier)
            if submission.result == "AC" {
                button.bezelColor = submissionDB.ACColor
            }
            else {
                button.bezelColor = submissionDB.WAColor
            }
            
            item.view = button
            submissionitems.append(item)
        }
        return submissionitems
    }
    
    
    func makeScrollView() -> NSScrollView {
        let views = self.submissionItems.compactMap { $0.view }
        let stackView = NSStackView(views: views)
        stackView.spacing = 1
        stackView.orientation = .horizontal
        let scrollView = NSScrollView(frame: CGRect(origin: .zero, size: stackView.fittingSize))
        scrollView.documentView = stackView
        return scrollView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func pushedProblemsButton(sender: NSButton) {
        guard let url = URL(string: sender.identifier!.rawValue) else {return}
        NSWorkspace.shared.open(url)
    }
}


