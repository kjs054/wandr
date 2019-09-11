//
//  CategoryViewModel.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/17/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//
import Foundation

struct CategoriesApiResponse {
    let categories: [PlaceCategory]
}

extension CategoriesApiResponse: Decodable {
    
    private enum CategoriesApiResponseCodingKeys: String, CodingKey {
        case categories = "categories"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CategoriesApiResponseCodingKeys.self)
        categories = try container.decode([PlaceCategory].self, forKey: .categories)
    }
}

class PlaceCategory: Decodable {
    var alias: String
    var title: String
    var emoji: String
    var parent: String
    var selected: Bool
    
    enum CategoryCodingKeys: String, CodingKey {
        case alias
        case emoji
        case title
        case parent
    }
    
    required init(from decoder: Decoder) throws {
        let categoryContainer = try decoder.container(keyedBy: CategoryCodingKeys.self)
        self.alias = try categoryContainer.decode(String.self, forKey: .alias)
        self.title = try categoryContainer.decode(String.self, forKey: .title)
        self.emoji = try categoryContainer.decode(String.self, forKey: .emoji)
        self.parent = try categoryContainer.decode(String.self, forKey: .parent)
        self.selected = false
    }
}
