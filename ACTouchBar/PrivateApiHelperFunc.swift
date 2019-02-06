//
//  PrivateApiHelperFunc.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/06.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

import Foundation

func presentSystemModal(touchBar: NSTouchBar, identifier: NSTouchBarItem.Identifier, placement: Int64?) {
    if #available(OSX 10.14, *) {
        if let place = placement {
            NSTouchBar.presentSystemModalTouchBar(touchBar, placement: place, systemTrayItemIdentifier: identifier)
        }
        else {
            NSTouchBar.presentSystemModalTouchBar(touchBar, systemTrayItemIdentifier: identifier)
        }
    }
    else {
        if let place = placement {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, placement: place, systemTrayItemIdentifier: identifier)
        }
        else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: identifier)
        }
    }
}

func minimizeSystemModal(touchBar: NSTouchBar) {
    if #available(OSX 10.14, *) {
        NSTouchBar.minimizeSystemModalTouchBar(touchBar)
    } else {
        NSTouchBar.minimizeSystemModalFunctionBar(touchBar)
    }
}

func dismissSystemModal(touchBar: NSTouchBar) {
    if #available(OSX 10.14, *) {
        NSTouchBar.dismissSystemModalTouchBar(touchBar)
    } else {
        NSTouchBar.dismissSystemModalFunctionBar(touchBar)
    }
}


