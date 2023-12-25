//
//  HomeViewModel.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import Foundation

class HomeViewModel {
    
    let manager = HomeManager.shared
    var movie: Movie?
    var movieItems = [MovieResult]()
    var movies = [MovieResult]()
    var favoriteMovies: [MovieResult] {
        return movieItems.filter { isFavorite(movie: $0) }
    }
    var errorCallback: ((String)->())?
    var successCallback: (()->())?
    var showAlertClosure: ((String, String) -> Void)?
    var selectedMovieIndex: Int = 0
    var favoriteMovieIDs: Set<Int> {
        didSet {
            saveFavorites()
        }
    }
    
    init() {
        self.favoriteMovieIDs = Set()
        self.loadFavorites()
    }
    
    func getCategorItems() {
        manager.getMovies(page: (movie?.page ?? 0) + 1) { [weak self] movie, error in
            if let error = error {
                self?.errorCallback?(error.localizedDescription)
            } else {
                self?.movie = movie
                if let movieItems = movie?.results, !movieItems.isEmpty {
                    self?.movieItems.append(contentsOf: movieItems)
                }
                self?.successCallback?()
            }
        }
    }
    
    func getMovieDetails(id: Int) {
        manager.getMovieDetail(movieId: id) { [weak self] movie, error in
            if let error = error {
                self?.errorCallback?(error.localizedDescription)
            } else {
                self?.movie = movie
                self?.successCallback?()
            }
        }
    }
    func isFavorite(movie: MovieResult) -> Bool {
        return favoriteMovieIDs.contains(movie.id)
    }
    
    func toggleFavorite(movie: MovieResult) {
        if isFavorite(movie: movie) {
            favoriteMovieIDs.remove(movie.id)
        } else {
            favoriteMovieIDs.insert(movie.id)
        }
        saveFavorites()
    }
    
    // MARK: - Persistence for Favorites
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteMovieIDs), forKey: "FavoriteMovies")
    }
    
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: "FavoriteMovies") as? [Int] {
            favoriteMovieIDs = Set(savedFavorites)
        }
    }
    
    func pagination(index: Int) {
        if let item = movie {
            if (item.page ?? 0 <= item.totalPages ?? 0) && index == (movieItems.count - 1) {
                getCategorItems()
            }
        }
    }
    
    func someOperation() {
        let errorMessage = "An error occurred"
        let errorTitle = "Error"
        showAlertClosure?(errorTitle, errorMessage)
    }
    
    func updateMovieIndex(_ index: Int) -> Void {
        self.selectedMovieIndex = index
    }
    
    func fetchMovieIndex() -> Int {
        return self.selectedMovieIndex
    }
    
    
}
