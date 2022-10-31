//
//  AuthHelper.swift
//  ListTopReddits
//
//  Created by nicolas castello on 31/10/2022.
//

import Foundation

class AuthHelper {
    
    static func needRefreshToken() -> Bool {
        guard let data = HandleUserDefaultHelper.getObjectFrom(key: .token) as? Data else { return false }
        
        do {
            let token = try PropertyListDecoder().decode(TokenResponse.self, from: data)
            let timeInterval = token.date?.timeDiferenceWith(date: Date())
            //21600 seconds is 6 hours
            return (timeInterval ?? 0 < 21600) ? false : true
        } catch {
            return false
        }
    }
    
    static func saveToken(token: TokenResponse, key: UserDefaultKey) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(token), forKey: UserDefaultKey.token.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func getRefreshToken(token: TokenResponse) async -> TokenResponse? {
        let webService = UrlSessionWebService()
        let repository = TopRedditsRepository(webService: webService)
        do {
            let result = try await repository.refreshToken(token: token)
            switch result {
            case .success(let token):
                saveToken(token: token, key: .token)
                return token
            case .failure(_):
                return nil
            }
        } catch {
            return nil
        }
    }
}
