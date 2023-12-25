//
//  UIView.swift
//  MovieTimeApp
//
//  Created by Furkan BAŞOĞLU on 25.12.2023.
//

import Foundation
import UIKit

extension UIView : Reusable { }

extension UIView {
    
    func addBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addOverlay(px: CGFloat, corners: CACornerMask? = nil) {
        DispatchQueue.main.async {
            self.layer.cornerRadius = px
            if let corners = corners{
                self.layer.maskedCorners = corners
            }
            self.clipsToBounds = true
        }
    }
    func makeCircleCorner() {
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
    }
    
    func addShadowAndOverlay(px: CGFloat, color: UIColor) {
        addOverlay(px: px)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.9
    }
    
    func addShadow(offset:CGSize = CGSize(width: 2, height: 2)) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.1
    }
    
    func addShadowWithRoundedCorners(color: UIColor, corners: UIRectCorner?, onlyLeftRight:Bool, radius: CGFloat){
        addOverlay(px: radius)
        
        let shadowOpacity:Float = 0.5
        let shadowSize:CGFloat = 5.0
        let visibleShadowSize:CGFloat = (CGFloat(shadowOpacity) * shadowSize)
        
        let shadowWidth:CGFloat = self.frame.size.width + shadowSize
        
        var shadowPath:UIBezierPath!
        
        if onlyLeftRight {
            shadowPath = UIBezierPath(rect: CGRect(x: -visibleShadowSize, y:visibleShadowSize+1.5, width: shadowWidth, height: self.bounds.size.height-shadowSize-3))
        }else{
            var shadowHeight:CGFloat = self.bounds.size.height + shadowSize
            
            let shadowX:CGFloat = -visibleShadowSize
            var shadowY:CGFloat = -visibleShadowSize
            
            if corners != nil {
                if !corners!.contains(.bottomRight){
                    //Not showin bottom shadow
                    shadowHeight = self.bounds.size.height - shadowSize
                }else if !corners!.contains(.topRight){
                    //Not showin top shadow
                    shadowY = radius
                    shadowHeight = self.bounds.size.height - radius + visibleShadowSize
                }
                
                shadowPath = UIBezierPath(roundedRect: CGRect(x: shadowX, y: shadowY, width:shadowWidth, height: shadowHeight), byRoundingCorners: corners!, cornerRadii: CGSize(width: radius, height: radius))
            }else{
                shadowPath = UIBezierPath(rect: CGRect(x:shadowX, y: shadowY, width: shadowWidth, height: shadowHeight))
            }
        }
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func curvedBottom(){
        let shapeLayer = CAShapeLayer(layer: self.layer)
    
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.bounds.size.width, y:self.bounds.size.height-20))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:self.bounds.size.height - 20), controlPoint: CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        shapeLayer.path = arrowPath.cgPath
        
        shapeLayer.frame = self.bounds
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
    }
    
    func curvedTop(){
        let shapeLayer = CAShapeLayer(layer: self.layer)
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addQuadCurve(to: CGPoint(x:self.bounds.size.width, y:0), controlPoint: CGPoint(x:self.bounds.size.width/2, y:20))
        arrowPath.addLine(to: CGPoint(x:self.bounds.size.width, y:self.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:self.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        shapeLayer.path = arrowPath.cgPath
        
        shapeLayer.frame = self.bounds
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
    }
    
    static func addTransparanBarcodeView(frame: CGRect, y:CGFloat, rectSize:CGSize) -> UIView {
        let overlayView = UIView(frame: frame)
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        overlayView.center = CGPoint(x: w/2, y: y)
        overlayView.frame.size.height = h
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        path.addRect(CGRect(x: w / 2 - ((rectSize.width) / 2), y: h / 2 - ((rectSize.height) / 2), width: rectSize.width, height: rectSize.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillRule = .evenOdd
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        return overlayView
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, realWidth:CGFloat? = nil) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0.0, y: 0.0, width: realWidth ?? self.frame.size.width, height: self.bounds.size.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func applyGradient(colours: [UIColor], realWidth:CGFloat? = nil) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: realWidth ?? self.frame.size.width, height: self.frame.size.height)
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x : 0.0, y : 1.0)
        gradient.endPoint = CGPoint(x :1.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
    
    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()

        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]

        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    static func instantiate(autolayout: Bool = true) -> Self {
        
        func instantiateUsingNib<T: UIView>(autolayout: Bool) -> T {
            let view = self.nib.instantiate() as! T
            view.translatesAutoresizingMaskIntoConstraints = !autolayout
            return view
        }
        return instantiateUsingNib(autolayout: autolayout)
    }
    
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.2,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0,
        corners: CACornerMask = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner],
        cornerRadius: CGFloat = 0)
    {

        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2
        
    
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
        

    }
    func setAnchorPoint(anchorPoint: CGPoint) {

        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)

        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)

        var position : CGPoint = self.layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x;

        position.y -= oldPoint.y;
        position.y += newPoint.y;

        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }
    
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil) else {
            fatalError("missing expected nib named: \(name)")
        }
        guard let view = nib.first as? Self else {
            fatalError("view of type \(Self.self) not found in \(nib)")
        }
        return view
    }
}

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}
