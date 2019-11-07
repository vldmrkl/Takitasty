//
//  RestaurantsViewController.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-06.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import UIKit

class RestaurantsViewController: UINavigationController, UITableViewDataSource {
    let restaurantsTableView = UITableView()
    var restaurants: [Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantsTableView.dataSource = self
        restaurantsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "restaurantCell")

        view.addSubview(restaurantsTableView)

        restaurantsTableView.translatesAutoresizingMaskIntoConstraints = false
        restaurantsTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        restaurantsTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        restaurantsTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        restaurantsTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        cell.textLabel?.text = restaurants[indexPath.row].name!
        return cell
    }
}
