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
    let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "food")
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor =  .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    @objc let fadeView = UIView()
    let gradientMaskLayer = CAGradientLayer()

    var restaurant: Restaurant?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.image = UIImage(named: "food")
    }

    func setUpLayout(){
        self.selectionStyle = .none

        self.contentView.addSubview(restaurantImageView)
        self.contentView.addSubview(nameLabel)

        restaurantImageView.centerXAnchor.constraint(equalTo:self.contentView.centerXAnchor).isActive = true
        restaurantImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        restaurantImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -30).isActive = true
        restaurantImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -30).isActive = true

        nameLabel.leadingAnchor.constraint(equalTo: restaurantImageView.leadingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: -5).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: restaurantImageView.widthAnchor, constant: -10).isActive = true
        nameLabel.numberOfLines = 0
        nameLabel.layer.zPosition = 2

        self.contentView.addSubview(fadeView)
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        fadeView.centerXAnchor.constraint(equalTo:self.contentView.centerXAnchor).isActive = true
        fadeView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        fadeView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -30).isActive = true
        fadeView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -30).isActive = true
        self.addObserver(self, forKeyPath: "fadeView.bounds", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "fadeView.bounds") {
            fadeView.setGradientBackground(colorOne: UIColor.clear, colorTwo: UIColor.black, opacity: 0.7, cornerRadius: 15.0)
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
