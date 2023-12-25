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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    var viewModel = HomeViewModel()
    var movieId: Int?
    var movie: MovieResult?
    var similarMovie = [MovieResult]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:String(describing: SimilarMoviesCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SimilarMoviesCollectionViewCell.self))
        arrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(arrowIconTap)))
        arrowImageView.isUserInteractionEnabled = true
        prepareNetwork()
        setupUI()
    }
    
    func prepareNetwork(){
        guard let movieId = movieId else { return }
        // Fetch details for the specified movie ID
        viewModel.getMovieDetails(id: movieId)
        viewModel.getSimilarMovies(id: movieId)
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
        collectionView.reloadData()
    }
    
    @objc fileprivate func arrowIconTap() {
        HomeViewController.present(from: self)
    }
    
    static func present(from: UIViewController, movieId: Int, movie: MovieResult, similarMovie: [MovieResult]) {
        let vc = DetailViewController.loadFromNib()
        vc.movieId = movieId
        vc.movie = movie 
        vc.similarMovie = similarMovie
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        from.present(vc, animated: false)
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        similarMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SimilarMoviesCollectionViewCell.self), for: indexPath) as! SimilarMoviesCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 143 / 375
        let height = collectionView.frame.height * 283 / 812
        return CGSize(width: width, height: collectionView.frame.height)
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

