//
//  Resaturant.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-06.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation

struct Restaurant {
    let id: Int?
    let name: String?
    let address: String?
    let url: String?
    let cuisines: String?
    let priceRange: Int?
    let featuredImageURL: String?

    init?(json: [String: Any]) {
        let id = json["id"] as? Int
        let name = json["name"] as? String
        var address = ""
        if  let location = json["location"] as? [String: Any] {
            address = location["address"] as! String
        }
        let url = json["url"] as? String
        let cuisines = json["cuisines"] as? String
        let priceRange = json["price_range"] as? Int
        let featuredImageURL = json["featured_image"] as? String

        self.id = id
        self.name = name
        self.address = address
        self.url = url
        self.cuisines = cuisines
        self.priceRange = priceRange
        self.featuredImageURL = featuredImageURL
    }
}
