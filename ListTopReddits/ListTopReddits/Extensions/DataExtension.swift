//
//  DataExtension.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import Foundation

extension Data {
    func decodedObject<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: self)
    }
    
    func printAsJSON() {
        #if DEBUG
        if let theJSONData = try? JSONSerialization.jsonObject(with: self, options: []) as? NSDictionary {
            var swiftDict: [String: Any] = [:]
            for key in theJSONData.allKeys {
                let stringKey = key as? String
                if let key = stringKey, let keyValue = theJSONData.value(forKey: key) {
                    swiftDict[key] = keyValue
                }
            }
            swiftDict.printAsJSON()
        }
        #endif
    }
}
