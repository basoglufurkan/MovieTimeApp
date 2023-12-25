//
//  UIViewController.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 25.12.2023.
//

import Foundation
import UIKit

extension UIViewController: Reusable {}

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: T.identifier, bundle: nil)
        }
        return instantiateFromNib()
    }
        
}
