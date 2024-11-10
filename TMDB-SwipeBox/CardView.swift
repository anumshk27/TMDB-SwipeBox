//
//  CardView.swift
//  TMDB-SwipeBox
//
//  Created by Haider Shahzad on 10/11/2024.
//

import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var shadowRadius: CGFloat = 6

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowRadius = shadowRadius
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
        self.clipsToBounds = true
        layer.shadowPath = shadowPath.cgPath

    }
    
}
