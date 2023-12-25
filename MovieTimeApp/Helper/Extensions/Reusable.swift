//
//  Reusable.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 25.12.2023.
//

import Foundation

protocol Reusable {
  static var identifier: String {get}
}

extension Reusable {
  static var identifier: String {
    return String(describing: self)
  }
}
