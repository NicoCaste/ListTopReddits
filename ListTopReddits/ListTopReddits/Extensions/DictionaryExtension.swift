//
//  DictionaryExtension.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation

extension Dictionary where Key: QueryEscapableString, Value: QueryEscapableString {
    func getUrlQuery() -> String {
        let urlparams = self.map({"\($0.addPercentEncoding())=\($1.addPercentEncoding())"}).joined(separator: "&")
        return urlparams
    }
}

extension Dictionary {
    func printAsJSON() {
        #if DEBUG
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("\(theJSONText)")
        }
        #endif
    }
}
