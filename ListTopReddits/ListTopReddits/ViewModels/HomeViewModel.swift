//
//  HomeViewModel.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import Foundation

protocol HomeViewModelProtocol {
    func getTopReddits(getAfter: Bool) async -> [RedditWithImage]
    var token: TokenResponse { get }
    init(token: TokenResponse)
}

class HomeViewModel: HomeViewModelProtocol {
    var token: TokenResponse
    var reddits: BestApiResponse?
    var redditsWithImage: [RedditWithImage] = []
    
    required init(token: TokenResponse) {
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
            case .failure(_):
               await showError()
            }
        } catch {
            await showError()
        }
        return []
    }
    
    @MainActor func showError() async {
        ShowErrorManager.showErrorView(title: "Ups".localized(), description: "genericError".localized())
    }
    
    func setRedditsWithImage() {
        reddits?.data?.children?.forEach({ children in
            if let childrenData = children.data {
                redditsWithImage.append(RedditWithImage(childrenData: childrenData))
            }
        })
    }
}
