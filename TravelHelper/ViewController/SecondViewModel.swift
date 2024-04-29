//
//  SecondViewModel.swift
//  TravelHelper
//
//  Created by Gabby Pierce on 4/3/24.
//
import Foundation

struct RestaurantResponse: Codable {
    let matchingResults: Int?
    let restaurants: [Restaurant]

    enum CodingKeys: String, CodingKey {
        case matchingResults = "matchingResults"
        case restaurants = "restaurants"
    }
}


struct Restaurant: Codable {
    let id: Int64
    let restaurantName: String?
    let address: String?
    let zipCode: String?
    let phone: String?
    let website: String?
    let email: String?
    let latitude: String?
    let longitude: String?
    let stateName: String?
    let cityName: String?
    let hoursInterval: String?
    let cuisineType: String?
    
    enum CodingKeys: String, CodingKey {
        case id, restaurantName, address, zipCode, phone, website, email, latitude, longitude, stateName, cityName, hoursInterval, cuisineType
    }
}

class SecondViewModel: ObservableObject {
     @Published var restaurants: [Restaurant] = []
    
    func fetchRestaurants(cityName: String, stateAbbreviation: String, completion: @escaping(Bool, Error?) -> Void) {
        let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let encodedStateAbbreviation = stateAbbreviation.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        
        // Use the encoded parameters in the URL
        let urlString = "https://restaurants-near-me-usa.p.rapidapi.com/restaurants/location/state/\(encodedStateAbbreviation)/city/\(encodedCityName)/0"
        guard let url = URL(string: urlString) else {
            completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Add your headers here
        //request.setValue("274d42e19cmsh3a6436ed8c04afbp1653f1jsn040500aa06cd", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("restaurants-near-me-usa.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
                
//        let session = URLSession.shared
//        session.dataTask(with: request) { (data, response, error) in
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion (false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected status code"]))
                }
                return
            }
            
            if let data = data {
                DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let decodedResponse = try JSONDecoder().decode(RestaurantResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.restaurants = decodedResponse.restaurants
                        completion(true, nil)
                    }
                }catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                }
            }
        }.resume()
    }
}

