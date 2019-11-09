//
//  ViewController.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-10-30.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let service = APIService()
    var city = UserDefaults.standard.string(forKey: "city") ?? "unknown location"
    var nearbyRestaurants: [Restaurant] = [] {
        didSet {
            let restaurantsVC = RestaurantsViewController()
            restaurantsVC.restaurants = nearbyRestaurants
            restaurantsVC.modalPresentationStyle = .fullScreen
            self.show(restaurantsVC, sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }

    func setUpLayout() {
        if let bgImage = UIImage(named: "food-bg") {
            let imageView = UIImageView(frame: self.view.bounds);
            let gradientLayerPoints =  [CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0)]

            imageView.image = bgImage
            imageView.contentMode = .scaleAspectFill
            self.view.addSubview(imageView)

            view.setGradientBackground(colorOne: Colors.lightBlue, colorTwo: Colors.darkBlue, opacity: 0.9, points: gradientLayerPoints)
            self.view.sendSubviewToBack(imageView)
        }


        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 100

        let logoStackView = UIStackView()
        logoStackView.axis = .vertical
        logoStackView.alignment = .center
        logoStackView.distribution = .equalSpacing
        logoStackView.spacing = 10


        if let logoImage = UIImage(named: "logo") {
            let logoImageView = UIImageView(image: logoImage)
            logoImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
            logoImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
            logoImageView.contentMode = .scaleAspectFit
            logoStackView.addArrangedSubview(logoImageView)
        }

        let nameLabel = UILabel()
        nameLabel.text = "takitasty".uppercased()
        nameLabel.textColor = .white
        nameLabel.font = UIFont(name: "Futura-Medium", size: 36.0)
        logoStackView.addArrangedSubview(nameLabel)

        mainStackView.addArrangedSubview(logoStackView)

        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .vertical
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.spacing = 10

        buttonsStackView.addArrangedSubview(createMenuButton(title: "All Restaurants", action: nil))
        buttonsStackView.addArrangedSubview(createMenuButton(title: "Restaurants Nearby", action: #selector(showRestaurants)))
        buttonsStackView.addArrangedSubview(createMenuButton(title: "I'm Feeling Lucky", action: nil))

        mainStackView.addArrangedSubview(buttonsStackView)

        let locationStackView = UIStackView()
        locationStackView.axis = .horizontal
        locationStackView.alignment = .center
        locationStackView.distribution = .equalSpacing
        locationStackView.spacing = 5

        if let locationIcon = UIImage(systemName: "location.fill") {

            let locationIconImageView = UIImageView(image: locationIcon.withTintColor(.white, renderingMode: .alwaysOriginal))
            locationIconImageView.widthAnchor.constraint(equalToConstant: 14.0).isActive = true
            locationIconImageView.heightAnchor.constraint(equalToConstant: 14.0).isActive = true

            locationIconImageView.contentMode = .scaleAspectFit
            locationStackView.addArrangedSubview(locationIconImageView)
        }

        let locationLabel = UILabel()
        locationLabel.text = "\(city)".uppercased()
        locationLabel.textColor = .white
        locationLabel.font = UIFont(name: "Futura-Medium", size: 14.0)
        locationStackView.addArrangedSubview(locationLabel)
        locationStackView.layoutMargins.top = 300


        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainStackView)
        mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true


        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(locationStackView)
        locationStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        locationStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true

    }

    func createMenuButton(title: String, action: Selector?) -> UIButton {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.layer.cornerRadius = 10.0
        menuButton.layer.masksToBounds = true
        menuButton.setTitle(title, for: .normal)
        menuButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 20.0)
        if let action = action {
            menuButton.addTarget(self, action: action, for: .touchUpInside)
        }
        menuButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 250).isActive = true

        return menuButton
    }

    @objc func testFunc(sender: UIButton) {
        print("kaboom")
    }

    @objc func showRestaurants(sender: UIButton) {
        let lat = UserDefaults.standard.double(forKey: "lat")
        let lon = UserDefaults.standard.double(forKey: "lon")
        print("\(lat) \(lon)")
        service.fetchRestaurants(lat, lon) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let restaurants): self?.nearbyRestaurants = restaurants
                case .failure: print("Couldn't fetch Restaurants")
                }
            }
        }
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
