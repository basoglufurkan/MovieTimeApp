//
//  DetailViewController.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 25.12.2023.
//

import UIKit
import AVFoundation
import PanModal

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    var viewModel = HomeViewModel()
    var movieId: Int?
    var movie: MovieResult?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        arrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(arrowIconTap)))
        arrowImageView.isUserInteractionEnabled = true
        prepareNetwork()
        setupUI()
    }
    
    func prepareNetwork(){
        guard let movieId = movieId else { return }
        // Fetch details for the specified movie ID
        viewModel.getMovieDetails(id: movieId)
    }
    
    func setupUI() {

        guard let movie = movie else {
            print("Movie data is not available")
            return
        }
        
        // Update the UI elements
        movieTitle.text = movie.titleText
        movieOverview.text = movie.overViewText
        movieImg.loadURL(url: movie.posterImage)
        rating.text = movie.ratingText
        genresCollectionView.reloadData()
    }
    
    @objc fileprivate func arrowIconTap() {
        HomeViewController.present(from: self)
    }
    
    static func present(from: UIViewController, movieId: Int, movie: MovieResult) {
        let vc = DetailViewController.loadFromNib()
        vc.movieId = movieId
        vc.movie = movie 
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        from.present(vc, animated: false)
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.movieItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCell", for: indexPath) as? GenresCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 48)
    }
    
}

extension DetailViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        nil
    }
    var showDragIndicator: Bool {
        false
    }
    var shortFormHeight: PanModalHeight {
        return .contentHeight(480)
    }
    var longFormHeight: PanModalHeight {
        return .contentHeight(800)
    }
    
}

