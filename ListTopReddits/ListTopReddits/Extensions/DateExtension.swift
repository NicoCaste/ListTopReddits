//
//  DateExtension.swift
//  ListTopReddits
//
//  Created by nicolas castello on 31/10/2022.
//

import Foundation

extension Date {
    func timeDiferenceWith(date: Date) -> TimeInterval {
        return date.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }
}
