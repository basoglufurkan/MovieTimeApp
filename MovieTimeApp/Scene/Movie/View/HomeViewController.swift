//
//  HomeViewController.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import UIKit

enum MovieSegment {
    case currentMovies
    case favorites
    
    init(index: Int) {
        switch index {
        case 0:
            self = .currentMovies
        default:
            self = .favorites
        }
    }
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customSegment: CustomSegment!
    var viewModel = HomeViewModel()
    private var currentSegment: MovieSegment = .currentMovies
    private var lastIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MovieTableViewCell.id, bundle: nil), forCellReuseIdentifier: "movieCell")
        setupUI()
        setupCustomSegment()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getCategorItems()
        viewModel.errorCallback = { [weak self] errorMessage in
            guard let self = self else { return }
            viewModel.showAlertClosure = { [weak self] title, message in
                self?.showAlert(title: "Error", message: errorMessage)
            }
        }
        viewModel.successCallback = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
    }
    func setupUI() {
        customSegment.layer.cornerRadius = 10
        customSegment.layer.shadowColor = UIColor.black.cgColor
        customSegment.layer.shadowOpacity = 3
        customSegment.layer.shadowOffset = .zero
        customSegment.layer.shadowRadius = 9
        customSegment.layer.borderColor = UIColor.systemGray5.cgColor
        customSegment.layer.borderWidth = 0.5
        customSegment.clipsToBounds = true
    }
    private func setupCustomSegment() {
        customSegment.delegate = self  // Set the delegate
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        SearchViewController.present(from: self)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow{
            viewModel.updateMovieIndex(indexPath.row)
        }
    }
    static func present(from: UIViewController) {
        DispatchQueue.main.async {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            loginVC.modalPresentationStyle = .fullScreen
            from.present(loginVC, animated: false, completion: nil)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSegment {
        case .currentMovies:
            return viewModel.movieItems.count
        case .favorites:
            return viewModel.favoriteMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie: MovieResult
        
        switch currentSegment {
        case .currentMovies:
            movie = viewModel.movieItems[indexPath.row]
        case .favorites:
            movie = viewModel.favoriteMovies[indexPath.row]
        }
        
        cell.configure(movie, isFavorite: viewModel.isFavorite(movie: movie))
        cell.onFavoriteTapped = { [weak self] in
            self?.viewModel.toggleFavorite(movie: movie)
            self?.tableView.reloadData()  // Reload to reflect favorite changes
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovieId = viewModel.movieItems[indexPath.row].id  // Get the selected movie ID
        let selectedMovie = viewModel.movieItems[indexPath.row]
        
        DetailViewController.present(from: self, movieId: selectedMovieId, movie: selectedMovie, similarMovie: viewModel.movieItems)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.pagination(index: indexPath.row)
    }
    
}

extension HomeViewController: CustomCartSegmentDelegate{
    func selectedIndex(at index: Int) {
        guard lastIndex != index else { return }
        lastIndex = index
        
        tableView.setContentOffset(.zero, animated: true)
        if index == 0 {
            currentSegment = .currentMovies
        } else {
            currentSegment = .favorites
        }
        tableView.setContentOffset(.zero, animated: true)
        
        tableView.reloadData()
    }
}
