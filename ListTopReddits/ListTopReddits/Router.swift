//
//  Router.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import Foundation
import UIKit

final class Router {
    
    @MainActor static func goToRootView(navigation: UINavigationController, token: TokenResponse) {
        let viewModel = HomeViewModel(token: token)
        let viewController = HomeViewController(viewModel: viewModel)
        navigation.pushViewController(viewController, animated: true)
    }

//    static func showErrorView(navigation: UINavigationController, message: ErrorMessage) {
//        let errorView = ErrorViewController()
//        errorView.errorMessage = message
//        navigation.pushViewController(errorView, animated: true)
//    }
//
    static func goToRedditDetail(navigation: UINavigationController, reddit: RedditWithImage) {
        let viewModel = RedditDetailViewModel(reddit: reddit)
        navigation.pushViewController(RedditDetailViewController(viewModel: viewModel), animated: true)
    }
}
