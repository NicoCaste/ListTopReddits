//
//  ErrorViewController.swift
//  ListTopReddits
//
//  Created by nicolas castello on 31/10/2022.
//

import UIKit

struct ErrorMessage {
    var title: String
    var description: String
}

class ErrorViewController: UIViewController {
    lazy var cardView: UIView = UIView()
    lazy var closeButton: UIButton = UIButton()
    lazy var errorImage: UIImageView = UIImageView()
    lazy var errorTitle: UILabel = UILabel()
    lazy var errorMessage: ErrorMessage? = nil
    lazy var errorDescription: UILabel = UILabel()
    let token: TokenResponse
    
    init(token: TokenResponse) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.setHidesBackButton(true, animated: true)
        configErrorImage()
        configCardView()
        configErrorTitle()
        configErrorDescription()
        configCloseButton()
    }
    
    func configCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 8
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            cardView.heightAnchor.constraint(equalToConstant: (self.view.bounds.height / 2))
        ])
    }
    
    func configErrorImage() {
        errorImage.image = UIImage(systemName: "video.slash") ?? UIImage()
        errorImage.tintColor = .white
        errorImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorImage)
        
        NSLayoutConstraint.activate([
            errorImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            errorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImage.heightAnchor.constraint(equalToConstant: 250),
            errorImage.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func configErrorTitle() {
        errorTitle.text = errorMessage?.title ?? ""
        errorTitle.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(errorTitle)
        errorTitle.font = UIFont(name: "Noto Sans Myanmar Bold", size: 30)
        errorTitle.textAlignment = .center
        errorTitle.textColor = .white
        errorTitle.numberOfLines = 0
        NSLayoutConstraint.activate([
            errorTitle.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 20),
            errorTitle.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 5),
            errorTitle.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -5)
        ])
    }
    
    func configErrorDescription() {
        errorDescription.text = errorMessage?.description ?? ""
        errorDescription.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(errorDescription)
        errorDescription.font = UIFont(name: "Noto Sans Myanmar Bold", size: 18)
        errorDescription.textAlignment = .center
        errorDescription.textColor = .white
        errorDescription.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            errorDescription.topAnchor.constraint(equalTo: errorTitle.bottomAnchor, constant: 10),
            errorDescription.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 5),
            errorDescription.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -5)
        ])
    }
    
    //MARK: SetCreatePlayListButton
    func configCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action:  #selector(dismissView), for: .touchUpInside)
        cardView.addSubview(closeButton)
        closeButton.setTitle("Close", for: .normal)
        closeButton.layer.masksToBounds = true
        closeButton.layer.cornerRadius = 5
        closeButton.backgroundColor = .systemGray
        guard let newFont = UIFont(name: "Noto Sans Myanmar Bold", size: 18) else { return }
        closeButton.titleLabel?.font = newFont
            
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: cardView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            closeButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func dismissView() {
        guard let navigation = self.navigationController else { return }
        Router.goToRootView(navigation: navigation, token: token)
    }
}
