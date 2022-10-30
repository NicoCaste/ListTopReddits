//
//  TopRedditsTableViewCell.swift
//  ListTopReddits
//
//  Created by nicolas castello on 29/10/2022.
//

import UIKit
import Foundation

class RedditWithImage {
    let childrenData: ChildrenData
    var image: UIImage?
    
    init(childrenData: ChildrenData) {
        self.childrenData = childrenData
    }
}

class TopRedditsTableViewCell: UITableViewCell {
    lazy private var topRedditsImage: UIImageView = UIImageView()
    lazy private var topRedditsDetail: UILabel = UILabel()
    private let defaultThumbnail = "default"
    private let defaultImage = UIImage(systemName: "camera")
    var reddit: RedditWithImage?
    
    func populate(reddit: RedditWithImage ) {
        self.backgroundColor = UIColor.clear
        self.reddit = reddit
        setTopRedditImage()
        setTopRedditDetail()
    }
    
    //MARK: SetPlaylistImage
    private func setTopRedditImage() {
        guard let reddit = reddit else { return }
        if let image = reddit.image {
            topRedditsImage.image = image
        } else {
            let image = getImage(from: reddit.childrenData.thumbnail ?? defaultThumbnail)
            reddit.image = image
            topRedditsImage.image = reddit.image
        }
        
        topRedditsImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topRedditsImage)
        topRedditsImage.contentMode = .scaleAspectFill
        topRedditsImage.layer.masksToBounds = true
        topRedditsImage.layer.cornerRadius = 4
        setImageLayout()
    }
    
    private func getImage(from imageUrl: String) -> UIImage {
        guard imageUrl != defaultThumbnail,
              let url = URL(string: imageUrl),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data)
        else {
            return defaultImage!
        }
        
        return image
    }

    //MARK: SetPlaylistDetail
    private func setTopRedditDetail() {
        guard let reddit = reddit else { return }
        topRedditsDetail.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topRedditsDetail)
        topRedditsDetail.text = reddit.childrenData.title
        topRedditsDetail.numberOfLines = 0
        topRedditsDetail.font = UIFont(name: "Noto Sans Myanmar semi Bold", size: 15)
        setDetailLayout()
    }
}

// MARK: - Layout
extension TopRedditsTableViewCell {
    // MARK: - Layout Image
    func setImageLayout() {
        NSLayoutConstraint.activate([
            topRedditsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            topRedditsImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            topRedditsImage.heightAnchor.constraint(equalToConstant: 90),
            topRedditsImage.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    // MARK: - Layout Title
    func setDetailLayout() {
        NSLayoutConstraint.activate([
            topRedditsDetail.leadingAnchor.constraint(equalTo: topRedditsImage.trailingAnchor, constant: 10),
            topRedditsDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            topRedditsDetail.topAnchor.constraint(equalTo: topRedditsImage.topAnchor),
            topRedditsDetail.heightAnchor.constraint(greaterThanOrEqualToConstant: 90),
            topRedditsDetail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
