//
//  TopRedditsRepository.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import Foundation

final class TopRedditsRepository {
    var webService: WebService
    
    init(webService: WebService) {
        self.webService = webService
    }
    
    func getBasicRequest(url: URL, components: URLComponents) -> URLRequest {
        let request = URLRequest(url: url)
        return request
    }
    
    func getComponents() -> URLComponents {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "redirect_uri", value: Constant.redirectUri)
        ]
        
        return components
    }
}

// MARK: - Get Best
extension TopRedditsRepository {
    
    func getBest(token: TokenResponse, next: String? = nil) async throws -> Result<BestApiResponse, Error>{
        var urlString = ApiCallerHelper.makeUrlFromOAuth(path: "best")
        
        if let next = next {
            let params = ["after" : next]
            urlString += "?" + params.getUrlQuery()
        }
        
        guard let url = URL(string: urlString) else { throw NetWorkingError.badURL }
        let request = getRequestForBest(url: url, token: token)
        return try await withCheckedThrowingContinuation({ continuation in
            webService.get(from: request, completion: { result in
                switch result {
                case .success(let data):
                    do {
                        let result: BestApiResponse = try data.decodedObject()
                        continuation.resume(returning: .success(result))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        })
    }
    
    func getComponentsForBest() -> URLComponents {
        var components = getComponents()
        components.queryItems?.append(URLQueryItem(name: "grant_type", value: "authorization_code"))
        return components
    }
    
    func getRequestForBest(url: URL, token: TokenResponse) -> URLRequest {
        let components = getComponentsForBest()
        var request = getBasicRequest(url: url, components: components)
        request.setOAuth2Token(token)
        request.setUserAgentForReddit()
        request.httpMethod = "GET"
        return request
    }
}

// MARK: - Post Token
extension TopRedditsRepository {
    
    func getToken(code: String ) async throws  -> Result<TokenResponse, Error> {
        let urlString = ApiCallerHelper.makeURLFromBasicUrl(path: "api/v1/access_token")
        guard let url = URL(string: urlString) else { throw NetWorkingError.badURL }
        let request = getTokenRequest(url: url, code: code)
        
        return try await withCheckedThrowingContinuation({ continuation in
            webService.get(from: request, completion: { result in
                switch result {
                case .success(let data):
                    do {
                        let token: TokenResponse = try data.decodedObject()
                        continuation.resume(returning: .success(token))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            })
        })
    }
    
    func getTokenRequest(url: URL, code: String) -> URLRequest {
        let components = getComponentForTokenRequest(code: code)
        var request = getBasicRequest(url: url, components: components)
        request.httpMethod = "POST"
        
        let user = Constant.user
        let password = ""
        let loginString = String(format: "%@:%@", user, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        return request
    }
    
    func getComponentForTokenRequest(code: String) -> URLComponents {
        var components = getComponents()
        components.queryItems?.append(URLQueryItem(name: "grant_type", value: "authorization_code"))
        components.queryItems?.append(URLQueryItem(name: "code", value: code))
        return components
    }
}
