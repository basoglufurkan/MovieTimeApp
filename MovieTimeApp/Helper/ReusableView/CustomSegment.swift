//
//  CustomSegment.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 25.12.2023.
//

import UIKit

protocol CustomCartSegmentDelegate: AnyObject{
    func selectedIndex(at index: Int)
}

class CustomSegment: CustomXibView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var movieView: UIView!
    
    
    private var containerViewIndex: Int = 1
    var isStore = true
    weak var delegate: CustomCartSegmentDelegate?
    
    override func setView() {
        super.setView()
        //        containerView.addOverlay(px: 12)
        //        containerView.addShadow(offset: CGSize(width: 10, height: 10))
        containerView.layer.cornerRadius = 6
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 3
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 9
        containerView.clipsToBounds = true
        
        containerView.backgroundColor = UIColor(hexString: "#F6F6F6")
        movieView.backgroundColor = UIColor(hexString: "#FFFFFF")
        favoritesView.backgroundColor = UIColor(hexString: "#E5E5E5")
    }
    
    func setSelectedSegment(index: Int) {
        
        if index == 0 {
            movieButtonPressed(index)
        } else {
            favoritesButtonPressed(index)
        }
    }
    
    @IBAction func movieButtonPressed(_ sender: Any) {
        delegate?.selectedIndex(at: 0)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.movieView.backgroundColor = UIColor(hexString: "#FFFFFF")
                self.favoritesView.backgroundColor = UIColor(hexString: "#F6F6F6")
                self.movieView.layer.cornerRadius = 6
            }
            
        }
    }
    
    @IBAction func favoritesButtonPressed(_ sender: Any) {
        if isStore {
            delegate?.selectedIndex(at: 1)
            UIView.animate(withDuration: 0.3) {
                self.movieView.backgroundColor = UIColor(hexString: "#F6F6F6")
                self.favoritesView.backgroundColor = UIColor(hexString: "#FFFFFF")
                self.favoritesView.layer.cornerRadius = 6
                
                
            }
        }else {
            delegate?.selectedIndex(at: 1)
        }
    }
}
