//
//  UrlRequestExtension.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation

extension URLRequest {
    mutating func setOAuth2Token(_ tokenResponse: TokenResponse?) {
        if let token = tokenResponse?.accessToken {
            setValue("bearer " + token, forHTTPHeaderField: "Authorization")
        }
    }
    
    mutating func setUserAgentForReddit() {
        let userAgent = "iOS:topsApp:v0.0.1 (by /u/No-Coast-8787)"
        self.setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
}
