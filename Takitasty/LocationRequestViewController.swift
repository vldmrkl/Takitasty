//
//  LocationRequestViewController.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-03.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit
import CoreLocation
import Lottie

class LocationRequestViewController: UIViewController, CLLocationManagerDelegate {
    private let service = APIService()
    var locationManager = CLLocationManager()
    var location: Location?  {
        didSet {
            let menuVC = ViewController()
            menuVC.modalPresentationStyle = .fullScreen
            if let cityName = location?.name {
                UserDefaults.standard.set(cityName, forKey: "city")
            }

            self.present(menuVC, animated: true, completion: nil)
        }
    }
    var spinner = UIActivityIndicatorView(style: .large)


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        setUpLayout()
    }

    @objc func getLocation(sender: UIButton) {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return

        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse){
            locationManager.requestLocation()

            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.backgroundColor = UIColor(white: 0.8, alpha: 0.75)
            spinner.layer.cornerRadius = 15.0

            spinner.startAnimating()
            self.view.addSubview(spinner)

            spinner.widthAnchor.constraint(equalToConstant: 100).isActive = true
            spinner.heightAnchor.constraint(equalToConstant: 100).isActive = true
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            UserDefaults.standard.set(lat, forKey: "lat")
            UserDefaults.standard.set(lon, forKey: "lon")
            fetchCity(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }

    func fetchCity(latitude: Double, longitude: Double) {
        service.fetchLocation(latitude, longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let location): self?.location = location
                case .failure: self?.location = nil
                }
            }
        }
    }

    func setUpLayout() {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 10

        let locationAnimationView = AnimationView(name: "locationAnimation")
        locationAnimationView.loopMode = LottieLoopMode.loop
        locationAnimationView.play()
        mainStackView.addArrangedSubview(locationAnimationView)

        let titleLabel = UILabel()
        titleLabel.text = "Find the best restaurants around"
        titleLabel.font = UIFont(name: "Avenir-Medium", size: 26.0)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        mainStackView.addArrangedSubview(titleLabel)

        let descriptionLabel = UILabel()
        descriptionLabel.text = "We will need your location to give you better experience"
        descriptionLabel.textAlignment = .center

        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.font = UIFont(name: "Avenir-Book", size: 18.0)
        mainStackView.addArrangedSubview(descriptionLabel)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainStackView)
        mainStackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true

        let locationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        let gradientLayerPoints =  [CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0)]
        locationButton.layer.cornerRadius = locationButton.frame.size.height / 2
        locationButton.setGradientBackground(colorOne: Colors.blue, colorTwo: Colors.lightBlue, opacity: 1.0, points: gradientLayerPoints)
        locationButton.layer.masksToBounds = true
        locationButton.setTitle("Enable Location Service", for: .normal)
        locationButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 20.0)
        locationButton.titleLabel?.textColor = .white
        locationButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        locationButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        locationButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(locationButton)
        locationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        locationButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true

    }
}
