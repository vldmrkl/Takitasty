//
//  UIView+Extension.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-03.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, opacity: Float = 1.0, cornerRadius: CGFloat = 0, points: [CGPoint]=[]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        if points.count == 2 {
            gradientLayer.startPoint = points[0]
            gradientLayer.endPoint = points[1]
        }
        
        gradientLayer.opacity = opacity
        gradientLayer.cornerRadius = cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
