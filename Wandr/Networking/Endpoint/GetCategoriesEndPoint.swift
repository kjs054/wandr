//
//  GooglePlacesEndPoint.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/29/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation



extension PlacesAPI: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://us-central1-wandr-244417.cloudfunctions.net") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .fetchPlaces:
            return "getPlaces"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchPlaces(let lon, let lat, let radius, let limit):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["lon": lon, "lat": lat, "radius": radius, "limit": limit])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
