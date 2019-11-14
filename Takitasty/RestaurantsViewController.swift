//
//  RestaurantsViewController.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-06.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit

class RestaurantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let restaurantsTableView = UITableView()
    var restaurants: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantsTableView.dataSource = self
        restaurantsTableView.delegate = self
        restaurantsTableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: "restaurantCell")
        view.addSubview(restaurantsTableView)
        
        restaurantsTableView.translatesAutoresizingMaskIntoConstraints = false
        restaurantsTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true

        restaurantsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        restaurantsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        restaurantsTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        restaurantsTableView.separatorStyle = .none
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell

        if let name = restaurants[indexPath.row].name {
            cell.nameLabel.text = name
        }

        if let imageURL = restaurants[indexPath.row].featuredImageURL {
            if let url = URL(string: imageURL), let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    cell.restaurantImageView.image = image
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantDetailsVC = RestaurantDetailsViewController()
        restaurantDetailsVC.restaurant = restaurants[indexPath.row]
        self.show(restaurantDetailsVC, sender: self)
    }
}
