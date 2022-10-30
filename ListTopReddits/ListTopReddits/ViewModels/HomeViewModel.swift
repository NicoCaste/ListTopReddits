//
//  HomeViewModel.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import Foundation

class HomeViewModel {
    var token: TokenResponse
    var reddits: BestApiResponse?
    var redditsWithImage: [RedditWithImage] = []
    
    init(token: TokenResponse) {
        self.token = token
    }
    
    func getTopReddits(getAfter: Bool) async -> [RedditWithImage] {
        let webService = UrlSessionWebService()
        let repository = TopRedditsRepository(webService: webService)
        let next = (getAfter) ? reddits?.data?.after : nil
        do {
            let bestReddits = try await repository.getBest(token: token, next: next)
            switch bestReddits {
            case .success(let reddits):
                redditsWithImage = []
                self.reddits = reddits
                setRedditsWithImage()
                return self.redditsWithImage
            case .failure(let error):
                print(error)
            }
        } catch {
            print(error)
        }
        return []
    }
    
    func setRedditsWithImage() {
        reddits?.data?.children?.forEach({ children in
            if let childrenData = children.data {
                redditsWithImage.append(RedditWithImage(childrenData: childrenData))
            }
        })
    }
}
