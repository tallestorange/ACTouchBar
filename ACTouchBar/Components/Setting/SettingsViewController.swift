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
        self.textField.stringValue = globalVars.shared.userName
        self.memoField.stringValue = globalVars.shared.slogan
    }
    
    @IBAction func pushOKButton(sender: NSButton) {
        let username = textField.stringValue
        let slogan = memoField.stringValue
        
        UserDefaults.standard.set(username, forKey: "userName")
        UserDefaults.standard.set(slogan, forKey: "slogan")
        
        globalVars.shared.userName = username
        globalVars.shared.slogan = slogan
        MainTouchBarController.shared.reloadAll()
    }
    
}
