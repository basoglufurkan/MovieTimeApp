//
//  Genre.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 25.12.2023.
//

import Foundation

struct Genre: Codable {
    let genres: [GenreElement]?
}

// MARK: - GenreElement
struct GenreElement: Codable {
    let id: Int?
    let name: String?
}
