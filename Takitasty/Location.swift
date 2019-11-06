//
//  Location.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-05.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation

struct Location {
    let id: Int
    let name: String
    let country: String

    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let country = json["country_name"] as? String else {
                return nil
        }

        self.id = id
        self.name = name
        self.country = country
    }
    
}
