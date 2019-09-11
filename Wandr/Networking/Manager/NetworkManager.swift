//
//  NetworkManager.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/29/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    enum Result {
        case success
        case failure(String)
    }
    
    enum NetworkResponse: String {
        case success
        case authenticationError = "You need to be authenticated first"
        case badRequest = "Bad Request"
        case outdated = "The request is outdated"
        case failed = "The request has failed"
        case noData = "No data was returned"
        case unableToDecode = "Could not decode data"
    }
    
    private let router = Router<PlacesAPI>()
    
    func getPlaces(lon: Double, lat: Double, radius: Double, limit: Int, category: String? = nil, completion: @escaping (_ place: [Place]?, _ error: String?) -> ()) {
        router.request(.getPlaces(lon: lon, lat: lat, radius: radius, limit: limit, categories: category)) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        if let JSONString = String(data: responseData, encoding: String.Encoding.utf8) {
                            print(JSONString)
                        }
                        let apiResponse = try JSONDecoder().decode(PlacesApiResponse.self, from: responseData)
                        completion(apiResponse.places, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func getCategories(completion: @escaping (_ category: [PlaceCategory]?, _ error: String?) -> ()) {
        router.request(.getCategories) { (data, response, error) in
            if error != nil {
                completion(nil, "Please check your network connection")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        if let JSONString = String(data: responseData, encoding: String.Encoding.utf8) {
                            print(JSONString)
                        }
                        let apiResponse = try JSONDecoder().decode(CategoriesApiResponse.self, from: responseData)
                        completion(apiResponse.categories, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
