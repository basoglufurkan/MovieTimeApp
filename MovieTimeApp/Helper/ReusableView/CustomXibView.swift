//
//  CustomXibView.swift
//  Karaca
//
//  Created by Fatih Doğan on 1.02.2023.
//  Copyright © 2023 BTPro. All rights reserved.
//

import Foundation
import UIKit

class CustomXibView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit (){
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.clear
        addSubview(view)
        clipsToBounds = true
        setView()
    }
    private func loadViewFromNib() -> UIView{
        let bundle =  Bundle(for: self.classForCoder)
        return UINib(nibName: Self.identifier, bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! UIView
    }
    func setView() { }
}
