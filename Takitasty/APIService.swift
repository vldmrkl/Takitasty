//
//  APIService.swift
//  Takitasty
//
//  Created by Volodymyr Klymenko on 2019-11-05.
//  Copyright © 2019 Volodymyr Klymenko. All rights reserved.
//

import Foundation

class APIService {
    let API_URL = URL(string: "https://developers.zomato.com/")!

    func fetchLocation(_ latitude: Double, _ longitude: Double, handler: @escaping (Result<Location, Error>) -> Void) {
        var urlComponents: URLComponents = URLComponents(url: API_URL, resolvingAgainstBaseURL: true)!
        urlComponents.path = "/api/v2.1//cities"
        urlComponents.queryItems =  [
           URLQueryItem(name: "lat", value: String(latitude)),
           URLQueryItem(name: "lon", value: String(longitude))
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(APIKey.value, forHTTPHeaderField: "User-Key")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var locationFromJSON: Location
            if let responseData = data, error == nil {
                do {
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        for case let locationSuggestion in json["location_suggestions"] as! [[String: Any]] {
                            if let location = Location(json: locationSuggestion) {
                                locationFromJSON = location
                                handler(.success(locationFromJSON))
                            }
                        }
                    }
                } catch {
                    handler(.failure(error))
                }
            }
        }.resume()
    }
}
