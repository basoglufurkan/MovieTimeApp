//
//  Extensions.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 24.12.2023.
//

import Foundation
import UIKit
import SDWebImage


extension UIApplication{
    func removeAllResponders(){
       self.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UINib {
    func instantiate() -> Any? {
        return self.instantiate(withOwner: nil, options: nil).first
    }
}
