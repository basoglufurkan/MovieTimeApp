//
//  NetworkManager.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    func requestMovie(url: String, method: HTTPMethod, completion: @escaping((Result<Movie, ErrorTypes>)->())) {
        guard isInternetAvailable() else {
            completion(.failure(.networkError))
            return
        }
        AF.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "", method: method).responseData { response in
            switch response.result {
            case .success(let data):
                self.handleMovieResponse(data: data) { response in
                    completion(response)
                }
            case .failure(let _):
                completion(.failure(.generalError))
            }
        }
    }
    
    fileprivate func handleMovieResponse(data: Data, completion: @escaping((Result<Movie, ErrorTypes>)->())) {
        do {
            let result = try JSONDecoder().decode(Movie.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(.invalidData))
        }
    }
    
    func isInternetAvailable() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
