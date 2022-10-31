//
//  RedditDetailViewModel.swift
//  ListTopReddits
//
//  Created by nicolas castello on 30/10/2022.
//

import Foundation
import UIKit

protocol RedditDetailViewModelProtocol {
    func set(backgroundNumericalValueFrom color: UIColor)
    func getTextColor() -> UIColor
    func getUrlImage() -> UIImage?
    var reddit: RedditWithImage { get }
    var token: TokenResponse { get }
    init(reddit: RedditWithImage, token: TokenResponse)
}

class RedditDetailViewModel: RedditDetailViewModelProtocol {
    var reddit: RedditWithImage
    var token: TokenResponse
    var backgroundNumericalValue: Double = 0
    
    required init(reddit: RedditWithImage, token: TokenResponse) {
        self.reddit = reddit
        self.token = token
    }
    
    func set(backgroundNumericalValueFrom color: UIColor) {
        let components = color.cgColor.components
        let red = (components?[0] ?? 0) * 299
        let blue = (components?[1] ?? 0) * 587
        let green = (components?[2] ?? 0) * 114
        let value = (red + blue + green) / 1000
        backgroundNumericalValue = value
    }
    
    //MARK: - Get TextColor
    func getTextColor() -> UIColor {
        return (backgroundNumericalValue > 0.5) ? .black : .white
    }
    
    func getUrlImage() -> UIImage? {
        guard let imageUrl = reddit.childrenData.url,
              let url = URL(string: imageUrl),
              let data = try? Data(contentsOf: url)
        else { return nil }
        
        let image = UIImage(data: data)
        return image
    }
}
