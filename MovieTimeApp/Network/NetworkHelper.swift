//
//  NetworkHelper.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import Foundation

enum ErrorTypes: String, Error {
    case invalidData = "Invalid data"
    case invalidURL = "Invalid url"
    case generalError = "An error happened"
    case networkError = "Network error"
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "739b7f7413c3cd2f643e52814d889927"
    private let imageBasePath = "https://image.tmdb.org/t/p/original/"
    
    func requestUrl(url: String) -> String {
        baseURL + url + "?api_key=\(apiKey)"
    }
    
    func getImagePath(url: String) -> String {
        imageBasePath + url
    }
}
