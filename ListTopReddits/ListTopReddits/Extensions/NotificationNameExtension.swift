//
//  NotificationNameExtension.swift
//  ListTopReddits
//
//  Created by nicolas castello on 31/10/2022.
//

import Foundation
extension NSNotification.Name {
    static var showErrorView: NSNotification.Name {
        return .init(rawValue: "showErrorView")
    }
}
