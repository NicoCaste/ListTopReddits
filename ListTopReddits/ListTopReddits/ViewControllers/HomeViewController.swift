//
//  HomeViewController.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import UIKit

class HomeViewController: UIViewController {
    let viewModel: HomeViewModelProtocol
    lazy var loading: UIActivityIndicatorView = UIActivityIndicatorView()
    @MainActor var topRedditsList: TopRedditsListView?
    var notificationCenter: NotificationCenter = NotificationCenter.default
    
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        title = "HomeTile".localized()
        self.view.backgroundColor = .systemGray
        setLoadling()
        Task.detached {
            try await self.getTopReddistListView()
            await self.setTopRedditsList()
        }
        notificationCenter.addObserver(self, selector: #selector(showErrorView(_:)), name: NSNotification.Name.showErrorView, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self, name: NSNotification.Name.showErrorView, object: nil)
    }
    
    @MainActor
    func getTopReddistListView() async throws {
        let bestReddits = await self.viewModel.getTopReddits(getAfter: false)
        self.topRedditsList = TopRedditsListView(frame: self.view.frame, reddist: bestReddits)
        loading.stopAnimating()
    }
    
    // MARK: - Set TopRedditsList
    func setTopRedditsList() {
        guard let topRedditsList = topRedditsList else { return }
        topRedditsList.delegate = self
        topRedditsList.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topRedditsList)
        layoutTopRedditsList()
    }
    
    // MARK: - Layout TopRedditsList
    func  layoutTopRedditsList() {
        guard let topRedditsList = topRedditsList else { return }
        NSLayoutConstraint.activate([
            topRedditsList.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topRedditsList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topRedditsList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topRedditsList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    //MARK: - ShowErrorView
    @objc func showErrorView(_ error: Notification) {
        guard let errorMessage = error.userInfo?["errorMessage"] as? ErrorMessage,
              let navigation = self.navigationController else { return }
        Router.showErrorView(navigation: navigation, message: errorMessage, token: viewModel.token)
    }
}

//MARK: - TopReddistList Delegate
extension HomeViewController: TopReddistListDelegate {
    func reloadBestReddist() async {
        let bestReddits = await self.viewModel.getTopReddits(getAfter: false)
        topRedditsList?.setBest(reddistWithImage: bestReddits)
    }
    
    func getMoreBest() async {
        let bestReddits = await self.viewModel.getTopReddits(getAfter: true)
        topRedditsList?.addBest(reddistWithImage: bestReddits)
    }
    
    func goToReddistDetail(reddit: RedditWithImage) {
        let url = reddit.childrenData.url
        if let url = url, url.contains(".jpg") || url.contains(".png")  {
            guard let navigation = navigationController else { return }
            Router.goToRedditDetail(navigation: navigation, reddit: reddit, token: viewModel.token)
        } else {
            showAlert()
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Sorry!", message: "We have not details to show you! ", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setLoadling() {
        loading.style = .large
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        view.bringSubviewToFront(loading)
        loading.startAnimating()
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
