//
//  Location.swift
//  Wandr
//
//  Created by Kevin Shiflett on 9/5/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

struct Location {
    var city: String
    var country: String
    var state: String
    var street: String
    var zip: String
}

extension Location: Decodable {
    
    enum LocationCodingKeys: String, CodingKey {
        case city
        case country
        case state
        case street = "address1"
        case zip_code
        case display_address
    }
    
    init(from decoder: Decoder) throws {
        do {
            let locationContainer = try decoder.container(keyedBy: LocationCodingKeys.self)
            self.city = try locationContainer.decode(String.self, forKey: .city)
            self.country = try locationContainer.decode(String.self, forKey: .country)
            self.state = try locationContainer.decode(String.self, forKey: .state)
            self.street = try locationContainer.decode(String.self, forKey: .street)
            self.zip = try locationContainer.decode(String.self, forKey: .zip_code)
        } catch {
            self.city = ""
            self.country = ""
            self.state = "MD"
            self.street = "dsf"
            self.zip = "3424"
            print(error)
        }
    }
}
