//
//  StringExtension.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation
public protocol QueryEscapableString {
    func addPercentEncoding() -> String
}

private let allowedCharacterSet = CharacterSet(charactersIn: "!$&'()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~")

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

extension String: QueryEscapableString {
    public func addPercentEncoding() -> String {
        return (self as NSString).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
    }
}
