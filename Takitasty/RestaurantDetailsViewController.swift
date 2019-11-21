//
//  RestaurantDetailsViewController.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-09.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailsViewController: UIViewController, MKMapViewDelegate {
    var restaurant: Restaurant?
    var mapView = MKMapView()
    @objc let fadeView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        mapView.delegate = self

        // Add a map pin for restaurant address
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString((restaurant?.address)!) {
            (placemarks, error) in
            if error != nil {
            } else if let placemarks = placemarks {
                if let coordinate = placemarks.first?.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    let mapCenter = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
                    annotation.coordinate = mapCenter
                    annotation.title = self.restaurant?.name
                    self.mapView.addAnnotation(annotation)

                    let region = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 500, longitudinalMeters: 500)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }

    func setUpLayout() {
        self.view.backgroundColor = UIColor(named: "appBackgroundColor")

        let imageView = UIImageView()
        imageView.image = UIImage(named: "food")
        if let imageURL = restaurant?.featuredImageURL {
            if let url = URL(string: imageURL), let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    imageView.image = image
                }
            }
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 3).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true

        let nameLabel = UILabel()
        nameLabel.text = restaurant?.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        nameLabel.textColor =  .white
        self.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -5).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: -10).isActive = true
        nameLabel.numberOfLines = 0
        nameLabel.layer.zPosition = 2

        self.view.addSubview(fadeView)
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        fadeView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        fadeView.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        fadeView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        fadeView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 3).isActive = true
        self.addObserver(self, forKeyPath: "fadeView.bounds", options: .new, context: nil)

        let dismissButton = UIButton()
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        let dismissIcon = UIImage(systemName: "xmark", withConfiguration: iconConfig)!.withTintColor(.white, renderingMode: .alwaysOriginal)
        dismissButton.setImage(dismissIcon, for: .normal)

        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        self.view.addSubview(dismissButton)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        dismissButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true

        let descriptionLabel = UILabel()
        descriptionLabel.text = descriptionBuilder()
        descriptionLabel.font = UIFont.systemFont(ofSize: 22)
        descriptionLabel.textColor =  UIColor(named: "mainTextColor")
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -30).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true


        descriptionLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -10).isActive = true
        descriptionLabel.numberOfLines = 0

        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo:self.view.centerXAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height / 4).isActive = true
        mapView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let lat = view.annotation?.coordinate.latitude
        let lon = view.annotation?.coordinate.longitude
        let url  = NSURL(string: "http://maps.apple.com/?q=\(lat!),\(lon!)")
        if UIApplication.shared.canOpenURL(url! as URL) == true
        {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        } else {
            NSLog("Can't use Apple Maps");
        }
    }

    @objc func dismissView(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "fadeView.bounds") {
            fadeView.setGradientBackground(colorOne: UIColor.clear, colorTwo: UIColor.black, opacity: 0.7)
            return
        }

        super.observeValue(
            forKeyPath: keyPath,
            of: object,
            change: change,
            context: context
        )
    }

    func descriptionBuilder() -> String {
        var description = ""
        description += ["This place", "This restaurant"].randomElement() ?? (restaurant?.name)!
        description += " "
        var foodType = ""

        if let cuisines = restaurant?.cuisines {
            foodType = cuisines.replacingOccurrences(of: ",", with: " and")
            description += ["is well-known for its", "specializes in", "serves"].randomElement()!
            description += " \(foodType) food. "
        }

        if let ratingText = restaurant?.ratingText {
            description += "It has "
            description += ratingText == "Average" ? "an" : "a"
            description += " \(ratingText.lowercased()) rating among the visitors. "
        }

        if let priceRange = restaurant?.priceRange {
            description += "Prices are "
            switch priceRange {
            case 1:
                description += "low."
            case 2:
                description += "medium."
            case 3:
                description += "high."
            case 4:
                description += "very high."
            default:
                description += "unknown."
            }
            description += "\n\n"
        }

        description += ["Come enjoy a delicious lunch, dinner, or late-night meal.", "Their staff are knowledgeable and attentive, providing quality service in a casual and comfortable atmosphere.", "The next time you want to try some of the best \(foodType) food, look no further than \((restaurant?.name)!)!"].randomElement()!


        return description
    }
}
