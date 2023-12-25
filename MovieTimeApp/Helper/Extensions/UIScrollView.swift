//
//  UIScrollView.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 25.12.2023.
//

import Foundation
import UIKit

extension UIScrollView {
   func scrollToBottom(animated: Bool) {
     if self.contentSize.height < self.bounds.size.height { return }
     let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
     self.setContentOffset(bottomOffset, animated: animated)
  }
}
