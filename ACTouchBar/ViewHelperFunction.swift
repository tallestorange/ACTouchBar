//
//  ViewHelperFunction.swift
//  ACTouchBar
//
//  Created by yt192 on 2019/02/07.
//  Copyright © 2019年 Yuhel Tanaka. All rights reserved.
//

func makeStackView(items: [NSCustomTouchBarItem]) -> NSStackView {
    let views = items.compactMap { $0.view }
    let stackView = NSStackView(views: views)
    stackView.spacing = 2
    stackView.orientation = .horizontal
    return stackView
}

func makeScrollView(stackView: NSStackView) -> NSScrollView {
    let scrollView = NSScrollView(frame: CGRect(origin: .zero, size: stackView.fittingSize))
    scrollView.documentView = stackView
    return scrollView
}

func epochSecondToDate(epochSecond: Int) -> Date {
    let date = Date(timeIntervalSince1970: TimeInterval(Double(epochSecond)))
    return date
}

func dateToString(date: Date) -> String {
    let dateFormater = DateFormatter()
    dateFormater.locale = Locale(identifier: "ja_JP")
    dateFormater.dateFormat = " yyyy/MM/dd "
    let dateString = dateFormater.string(from: date)
    return dateString
}

func makeTextItem(string: String, font: NSFont, color: NSColor?) -> NSCustomTouchBarItem {
    let item = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(rawValue: string))
    let textField = NSTextField.init(labelWithString: string)
    
    textField.font = font    
    if let textColor = color {
        textField.textColor = textColor
    }
    
    item.view = textField
    
    return item
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
