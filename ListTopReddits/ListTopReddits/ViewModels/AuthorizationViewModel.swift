//
//  AuthorizationViewModel.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import Foundation
import WebKit

protocol AuthViewModelProtocol {
    func getUIComponent(url: URL?, authStatus: AuthStatus) -> String?
    func saveToken(token: TokenResponse, key: UserDefaultKey)
    func getWebView () -> WKWebView
    func getWebViewUrl() -> URL?
    func getToken(code: String) async throws -> Result<TokenResponse, Error>
}

enum AuthStatus {
    case success
    case rejected
}

class AuthorizationViewModel: AuthViewModelProtocol {
    
    func getToken(code: String) async throws -> Result<TokenResponse, Error> {
        let repository = TopRedditsRepository(webService: UrlSessionWebService())
        return try await repository.getToken(code: code)
    }
    
    func getWebViewUrl() -> URL? {
        let scopes = ["identity", "edit", "flair", "history", "modconfig", "modflair", "modlog", "modposts", "modwiki", "mysubreddits", "privatemessages", "read", "report", "save", "submit", "subscribe", "vote", "wikiedit", "wikiread"]
        let scope = scopes.joined(separator: ",")
        let params = AuthParams(user: Constant.user, redirectUri: Constant.redirectUri, responseType: "code", state: "response", duration: "permanent", scope: scope)
        let url = ApiCallerHelper.getWebViewAuthUrl(with: params)
        return URL(string: url)
    }
    
    func getWebView () -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }
    
    func getUIComponent(url: URL?, authStatus: AuthStatus) -> String? {
        guard let url = url else { return nil }
        var name = ""
        switch authStatus {
        case .success:
            name = "code"
        case .rejected:
            name = "error"
        }
        
        return URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == name})?.value
    }
    
    func saveToken(token: TokenResponse, key: UserDefaultKey) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(token), forKey: UserDefaultKey.token.rawValue)
        UserDefaults.standard.synchronize()
    }
}
