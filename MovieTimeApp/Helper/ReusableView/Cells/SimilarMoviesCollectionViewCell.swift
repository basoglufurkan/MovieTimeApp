//
//  SimilarMoviesCollectionViewCell.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 25.12.2023.
//

import UIKit

class SimilarMoviesCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(_ item : MovieResult) {
        titleLabel.text = item.titleText
        ratingLabel.text = item.ratingText
        movieImageView.loadURL(url: item.posterImage)
    }
}
