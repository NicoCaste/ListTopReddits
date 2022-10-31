//
//  RedditViewController.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import UIKit

class RedditDetailViewController: UIViewController {
    lazy var backImageTarget: UIImageView = UIImageView()
    lazy var loading: UIActivityIndicatorView = UIActivityIndicatorView()
    @MainActor lazy var imageView: UIImageView = UIImageView()
    lazy var authorTitleLabel: UILabel = UILabel()
    lazy var releaseDateLabel: UILabel = UILabel()
    lazy var saveImageButton: UIButton = UIButton()
    lazy var detailTitleLabel: UILabel = UILabel()
    lazy var detailDescriptionLabel: UILabel = UILabel()
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var contentView: UIView = UIView()
    lazy var filterColorView: UIView = UIView()
    lazy var contentViewBackground: UIImageView = UIImageView()
    let viewModel: RedditDetailViewModel
    var saved: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setScrollView()
        setContentView()
        setCustomBackButton()
        setImageView()
        setAuthorTitleLabel()
        setReleaseDateLabel()
        setSaveImageButton()
        setDetailTitleLabel()
        setDetailDescriptionLabel()
        setLoadling()
    }
    
    init(viewModel: RedditDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum SubscribedTitle: String {
        case subscribed = "subscribed"
        case unSubscribe = "subscribe"
    }
    
    // MARK: - MovieImage
    func setRedditImage() {
        guard let color = viewModel.reddit.image?.averageColor else { return }
        setColorFilterView(color: color.withAlphaComponent(0.9))
        Task {
            let image = self.viewModel.getUrlImage()
            self.set(image: image)
        }
    }
    
    @MainActor func set(image: UIImage?) {
        let thumbnail =  viewModel.reddit.image
        let detailImage: UIImage = (image != nil) ? image! : thumbnail!
        viewModel.reddit.image = detailImage
        imageView.image = detailImage
        loading.stopAnimating()
    }
    
    // MARK: - closeView
    @objc func closeView(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - subscribeFilms
    @objc func saveImage() {
        loading.startAnimating()
        guard let image = viewModel.getUrlImage(),
              let pngImage = image.pngData()  ,
              let imageFinal = UIImage(data: pngImage)
        else { return }
        writeToPhotoAlbum(image: imageFinal)
    }

    func writeToPhotoAlbum(image: UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            showAlert(title: "Ups!", message: "we cant save the image!", action: goToSetting)
            return
        }
        
        setSavedButton()
        loading.stopAnimating()
    }
    
    // MARK: - SubscribeButtonContent
    func setSubscribeButtonContent() {
        saveImageButton.setTitle("Save Image", for: .normal)
    }
    
    func showAlert(title: String, message: String, action: ((_ alert: UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: action))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func goToSetting(_ alert: UIAlertAction) {
        guard let seeingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(seeingsUrl) {
            UIApplication.shared.open(seeingsUrl, completionHandler: { success in
                print(success)
            })
        }
    }
    
    func setSavedButton() {
        saveImageButton.setTitle("Saved Image", for: .normal)
        saveImageButton.setTitleColor(.black, for: .normal)
        saveImageButton.backgroundColor = .white
        
        if saved {
            showAlert(title: "Hey!", message: "This image was already saved", action: nil)
        } else {
            showAlert(title: "Great!", message: "We already saved the image!", action: nil)
            saved = true
        }
    }
    
    func setLoadling() {
        loading.style = .large
        loading.color = .white
        loading.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loading)
        contentView.bringSubviewToFront(loading)
        loading.startAnimating()
        loading.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

//MARK: ConfigViews
extension RedditDetailViewController {
    //MARK: - Set ScrollView
    func setScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        layoutScrollView()
    }
    
    //MARK: - Set ContentView
    func setContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        setBackgroundImage()
        layoutContentView()
    }
    
    //MARK: - Set ImageView
    func setImageView() {
        setRedditImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        layoutImageView()
    }
    
    //MARK: - Set BackgroundImage
    func setBackgroundImage() {
        contentViewBackground.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentViewBackground)
        self.view.sendSubviewToBack(contentViewBackground)
        
        contentViewBackground.contentMode =  .scaleAspectFill
        contentViewBackground.clipsToBounds = true
        
        contentViewBackground.image = viewModel.reddit.image
        layoutBackgroundImage()
    }
    
    //MARK: - Set ColorFilterView
    func setColorFilterView(color: UIColor) {
        viewModel.set(backgroundNumericalValueFrom: color)
        filterColorView .translatesAutoresizingMaskIntoConstraints = false
        contentViewBackground.addSubview(filterColorView)
        filterColorView .backgroundColor = color
        setSubscribeButtonContent()
        layoutFilterColorView()
    }
    
    //MARK: - Set CustomBackButton
    func setCustomBackButton() {
        backImageTarget.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backImageTarget)
        let image: UIImage = UIImage(systemName: "arrow.backward.circle.fill") ?? UIImage()
        backImageTarget.image = image
        backImageTarget.tintColor = .white
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeView(tapGestureRecognizer:)))
        backImageTarget.isUserInteractionEnabled = true
        backImageTarget.addGestureRecognizer(tapGesture)
        layoutCustomBackButton()
    }
    
    //MARK: - Set MovieTitleLabel
    func setAuthorTitleLabel() {
        authorTitleLabel.text = "Author: " + (viewModel.reddit.childrenData.author ?? "Unknow").capitalized
        authorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorTitleLabel)
        authorTitleLabel.numberOfLines = 0
        authorTitleLabel.textColor = viewModel.getTextColor()
        authorTitleLabel.textAlignment = .center
        authorTitleLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 24)
        layoutMovieTitleLabel()
    }
    
    //MARK: - ReleaseDateLabel
    func setReleaseDateLabel() {
        guard let createdUtc = viewModel.reddit.childrenData.createdUtc else { return }
        let timeInverval = Double(createdUtc)
        let date = Date(timeIntervalSince1970: timeInverval)
        releaseDateLabel.text = date.formatted(date: .long, time: .omitted)
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.textAlignment = .center
        releaseDateLabel.textColor = viewModel.getTextColor()
        releaseDateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(20)
        layoutReleaseDateLabel()
    }
    
    //MARK: - SubscribeButton
    func setSaveImageButton() {
        saveImageButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveImageButton)
        setSubscribeButtonContent()
        saveImageButton.titleLabel?.font = UIFont(name: "Noto Sans Myanmar Bold", size: 20)
        saveImageButton.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        saveImageButton.layer.cornerRadius = 45/2
        saveImageButton.layer.borderWidth = 2
        saveImageButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        layoutSubscribeButton()
    }
    
    //MARK: - DetailTitleLabel
    func setDetailTitleLabel() {
        detailTitleLabel.text = "Overview".uppercased()
        detailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailTitleLabel)
        detailTitleLabel.textColor = viewModel.getTextColor()
        detailTitleLabel.textAlignment = .left
        detailTitleLabel.font = UIFont(name: "Noto Sans Myanmar Bold", size: 18)
        layoutDetailTitleLabel()
    }
    
    // MARK: - DetailDescriptionLabel
    func setDetailDescriptionLabel() {
        detailDescriptionLabel.text = viewModel.reddit.childrenData.title
        detailDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailDescriptionLabel)
        detailDescriptionLabel.textColor = viewModel.getTextColor()
        detailDescriptionLabel.textAlignment = .left
        detailDescriptionLabel.numberOfLines = 0
        detailDescriptionLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(18)
        layoutDetailDescriptionLabel()
    }
}

//MARK: Layout
extension RedditDetailViewController {
    // MARK: - Layout ScrollView
    func layoutScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Layout ContentView
    func layoutContentView() {
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: Layout ImageView
    func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 43),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    //MARK: - Layout BackgroundImage
    func layoutBackgroundImage() {
        NSLayoutConstraint.activate([
            contentViewBackground.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentViewBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentViewBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentViewBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // MARK: - Layout FilterColorView
    func layoutFilterColorView() {
        NSLayoutConstraint.activate([
            filterColorView.leadingAnchor.constraint(equalTo: contentViewBackground.leadingAnchor),
            filterColorView.trailingAnchor.constraint(equalTo: contentViewBackground.trailingAnchor),
            filterColorView.topAnchor.constraint(equalTo: contentViewBackground.topAnchor),
            filterColorView.bottomAnchor.constraint(equalTo: contentViewBackground.bottomAnchor)
        ])
    }
    
    // MARK: - Layout MovieTitleLabel
    func layoutMovieTitleLabel() {
        NSLayoutConstraint.activate([
            authorTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 23),
            authorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            authorTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35)
        ])
    }
    
    // MARK: - Layout ReleaseDateLabel
    func layoutReleaseDateLabel() {
        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant: 2),
            releaseDateLabel.centerXAnchor.constraint(equalTo: authorTitleLabel.centerXAnchor)
        ])
    }
    
    // MARK: - Layout SubscribeButton
    func layoutSubscribeButton() {
        NSLayoutConstraint.activate([
            saveImageButton.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 20),
            saveImageButton.centerXAnchor.constraint(equalTo: releaseDateLabel.centerXAnchor),
            saveImageButton.heightAnchor.constraint(equalToConstant: 45),
            saveImageButton.widthAnchor.constraint(equalToConstant: 195)
        ])
    }
    
    // MARK: - Layout DetailTitleLabel
    func layoutDetailTitleLabel() {
        NSLayoutConstraint.activate([
            detailTitleLabel.topAnchor.constraint(equalTo: saveImageButton.bottomAnchor, constant: 45),
            detailTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Layout DetailDescriptionLabel
    func layoutDetailDescriptionLabel() {
        NSLayoutConstraint.activate([
            detailDescriptionLabel.topAnchor.constraint(equalTo: detailTitleLabel.bottomAnchor, constant: 10),
            detailDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            detailDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    // MARK: - Layout CustomBackButton
    func layoutCustomBackButton() {
        NSLayoutConstraint.activate([
            backImageTarget.heightAnchor.constraint(equalToConstant: 28),
            backImageTarget.widthAnchor.constraint(equalToConstant: 28),
            backImageTarget.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            backImageTarget.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 25)
        ])
    }
}
