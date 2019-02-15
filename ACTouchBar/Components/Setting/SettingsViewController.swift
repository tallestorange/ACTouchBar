//
//  SettingsViewController.swift
//  ACTouchBar
//
//  Created by Yuhel Tanaka on 2019/02/15.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {

    @IBOutlet var textField:NSTextField!
    @IBOutlet var memoField:NSTextField!
    @IBOutlet var okButton:NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func pushOKButton(sender: NSButton) {
        globalVars.shared.userName = textField.stringValue
        globalVars.shared.slogan = memoField.stringValue
        MainTouchBarController.shared.reloadAll()
    }
    
}
