//
//  HomeManager.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import Foundation
import UIKit

protocol HomeManagerProtocol {
    func getMovies(page: Int, complete: @escaping((Movie?, Error?)->()))
    func getSearchItems(text: String, page: Int, complete: @escaping((Movie?, Error?)->()))
}

class HomeManager: HomeManagerProtocol {
    static let shared = HomeManager()
    
    func getMovies(page: Int, complete: @escaping ((Movie?, Error?) -> ())) {
        NetworkManager.shared.requestMovie(url: "\(NetworkHelper.shared.requestUrl(url: "movie/upcoming"))" + "&page=\(page)", method: .get) { response in
            switch response {
            case .success(let data):
                complete(data, nil)
            case .failure(let error):
                complete(nil, error)
            }
        }
    }
    
    func getSearchItems(text: String, page: Int, complete: @escaping ((Movie?, Error?) -> ())) {
        NetworkManager.shared.requestMovie(url: "\(NetworkHelper.shared.requestUrl(url: "search/movie"))" + "&query=\(text)&page=\(page)", method: .get) { response in
            switch response {
            case .success(let data):
                complete(data, nil)
            case .failure(let error):
                complete(nil, error)
            }
        }
        
    }
    
    func getMovieDetail(movieId: Int, complete: @escaping ((Movie?, Error?) -> ())) {
        NetworkManager.shared.requestMovie(url: "https://api.themoviedb.org/3/movie/\(movieId)", method: .get) { response in
            switch response {
            case .success(let data):
                complete(data, nil)
            case .failure(let error):
                complete(nil, error)
            }
        }
    }
    
    func getSimilarMovie(movieId: Int, complete: @escaping ((Movie?, Error?) -> ())) {
        NetworkManager.shared.requestMovie(url: "https://api.themoviedb.org/3/movie/\(movieId)/similar", method: .get) { response in
            switch response {
            case .success(let data):
                complete(data, nil)
            case .failure(let error):
                complete(nil, error)
            }
        }
    }
    
    
}

enum SearchEndpoint: String {
    case search = "search/movie"
    
    var path: String {
        NetworkHelper.shared.requestUrl(url: "search/movie")
    }
}

