//
//  RestaurantTableViewCell.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-07.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation
import UIKit

class RestaurantTableViewCell: UITableViewCell {
    let restaurantImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "food")
        img.layer.cornerRadius = 15
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()

    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor =  .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    @objc let maskedView = UIView()
    let gradientMaskLayer = CAGradientLayer()

    var restaurant: Restaurant? {
        didSet {
            guard let restaurantItem = restaurant else {return}
            if let name = restaurantItem.name {
                nameLabel.text = name
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(restaurantImage)
        self.contentView.addSubview(nameLabel)

        restaurantImage.centerXAnchor.constraint(equalTo:self.contentView.centerXAnchor).isActive = true
        restaurantImage.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        restaurantImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -30).isActive = true
        restaurantImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -30).isActive = true

        nameLabel.leadingAnchor.constraint(equalTo: restaurantImage.leadingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: restaurantImage.bottomAnchor, constant: -5).isActive = true
        nameLabel.layer.zPosition = 2
        self.contentView.addSubview(maskedView)
        maskedView.translatesAutoresizingMaskIntoConstraints = false
        maskedView.centerXAnchor.constraint(equalTo:self.contentView.centerXAnchor).isActive = true
        maskedView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        maskedView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -30).isActive = true
        maskedView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -30).isActive = true
        self.addObserver(self, forKeyPath: "maskedView.bounds", options: .new, context: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "maskedView.bounds") {
            maskedView.setGradientBackground(colorOne: UIColor.clear, colorTwo: UIColor.black, opacity: 0.7, cornerRadius: 15.0)
            return
        }

        super.observeValue(
            forKeyPath: keyPath,
            of: object,
            change: change,
            context: context
        )
    }

}
