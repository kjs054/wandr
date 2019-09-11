//
//  GooglePlacesEndPoint.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/29/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum PlacesAPI {
    case getPlaces(lon: Double, lat: Double, radius: Double, limit: Int, categories: String?)
    case getCategories
}

extension PlacesAPI: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://us-central1-wandr-244417.cloudfunctions.net") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getPlaces: return "getPlaces"
        case .getCategories: return "getCategories"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .getPlaces(let lon, let lat, let radius, let limit, let category):
            if let category = category {
                return .requestParameters(bodyParameters: nil,
                                          urlParameters: ["lon": lon, "lat": lat, "radius": radius, "limit": limit, "categories": category])
            } else {
                return .requestParameters(bodyParameters: nil,
                                          urlParameters: ["lon": lon, "lat": lat, "radius": radius, "limit": limit])
            }
        case .getCategories:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
