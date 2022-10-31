//
//  AuthorizationViewController.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//
import UIKit
import WebKit

class AuthorizationViewController: UIViewController, WKNavigationDelegate {
    var viewModel: AuthViewModelProtocol?
    var webView: WKWebView?
    
    init(viewModel: AuthViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        guard let webView = webView else { return }
        webView.frame = view.bounds
    }
    
    func configView() {
        guard let url = viewModel?.getWebViewUrl() else { return }
        webView = viewModel?.getWebView()
        guard let webView = webView else { return }
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        guard let code = viewModel?.getUIComponent(url: webView.url, authStatus: .success)
        else {
            let error = viewModel?.getUIComponent(url: webView.url, authStatus: .rejected)
            return (error != nil) ? .cancel : .allow
        }
        
        webView.isHidden = true
        
        Task.detached { [weak self] in
            let response = try await self?.viewModel?.getToken(code: code)
            switch response {
            case .success(let token):
                await self?.viewModel?.saveToken(token: token, key: .token)
                guard let navigation = await self?.navigationController else { return }
                await Router.goToRootView(navigation: navigation, token: token)
            case .failure(_):
                await self?.showError()
            case .none:
                await self?.showError()
            }
        }
        
        return .allow
    }
    
    @MainActor func showError() async {
        ShowErrorManager.showErrorView(title: "Ups".localized(), description: "genericError".localized())
    }
}
