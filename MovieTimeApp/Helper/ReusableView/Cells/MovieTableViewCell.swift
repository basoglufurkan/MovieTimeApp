//
//  MovieTableViewCell.swift
//  MovieTime
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import UIKit
//import Cosmos
//import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var capsuleView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieTotalRatingLabel: UILabel!
    var onFavoriteTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        movieImageView.layer.cornerRadius = 10
        movieImageView.clipsToBounds = true
        movieImageView.layer.shadowColor = UIColor.black.cgColor
        movieImageView.layer.shadowOpacity = 0.5
        movieImageView.layer.shadowRadius = 8
        capsuleView.layer.cornerRadius = 6
        capsuleView.layer.shadowColor = UIColor.white.cgColor
        capsuleView.layer.shadowOpacity = 0.5
        capsuleView.layer.shadowRadius = 8
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFavoriteTap))
        favoriteImageView.addGestureRecognizer(tapGesture)
        favoriteImageView.isUserInteractionEnabled = true
    }
    
    @objc private func handleFavoriteTap() {
        onFavoriteTapped?()
    }
    
    func configure(_ item : MovieResult, isFavorite: Bool = false){
        movieTitleLabel.text = item.titleText
        movieTotalRatingLabel.text = "\(item.ratingText)"
        movieImageView.loadURL(url: item.posterImage)
        updateFavoriteIcon(isFavorite: isFavorite)
        
    }
    
    private func updateFavoriteIcon(isFavorite: Bool) {
        let systemName = isFavorite ? "star.fill" : "star"
        favoriteImageView.image = UIImage(systemName: systemName)
        favoriteImageView.tintColor = isFavorite ? .yellow : .gray
    }
}
