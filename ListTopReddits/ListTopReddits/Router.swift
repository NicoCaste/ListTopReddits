//
//  Router.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import Foundation
import UIKit

@MainActor final class Router {
    static func goToRootView(navigation: UINavigationController, token: TokenResponse) {
        let viewModel = HomeViewModel(token: token)
        let viewController = HomeViewController(viewModel: viewModel)
        navigation.pushViewController(viewController, animated: true)
    }

    static func showErrorView(navigation: UINavigationController, message: ErrorMessage, token: TokenResponse) {
        let errorView = ErrorViewController(token: token)
        errorView.errorMessage = message
        navigation.pushViewController(errorView, animated: true)
    }

    static func goToRedditDetail(navigation: UINavigationController, reddit: RedditWithImage, token: TokenResponse) {
        let viewModel = RedditDetailViewModel(reddit: reddit, token: token)
        navigation.pushViewController(RedditDetailViewController(viewModel: viewModel), animated: true)
    }
}
