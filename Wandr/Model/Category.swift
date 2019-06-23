//
//  CategoryViewModel.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/17/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//
import Foundation

let categoryFilters = [PlaceCategory(categoryName: "Pizza Places", categoryEmoji: "🍕", categoryId: 01, recWeight: 0.999),
                       PlaceCategory(categoryName: "Burger Joints", categoryEmoji: "🍔", categoryId: 02, recWeight: 0.832),
                       PlaceCategory(categoryName: "Movie Theatres", categoryEmoji: "🍿", categoryId: 03, recWeight: 0.314),
                       PlaceCategory(categoryName: "Restaurants", categoryEmoji: "🍽", categoryId: 04, recWeight: 0.970),
                       PlaceCategory(categoryName: "Stadiums", categoryEmoji: "🏟", categoryId: 05, recWeight: 0.212),
                       PlaceCategory(categoryName: "Amusement", categoryEmoji: "🎡", categoryId: 06, recWeight: 0.452),
                       PlaceCategory(categoryName: "Japanese Restaurants", categoryEmoji: "🍣", categoryId: 07, recWeight: 0.543),
                       PlaceCategory(categoryName: "Chinese Restaurants", categoryEmoji: "🥡", categoryId: 08, recWeight: 0.873),
                       PlaceCategory(categoryName: "Cocktail Bars", categoryEmoji: "🍸", categoryId: 09, recWeight: 0.163),
                       PlaceCategory(categoryName: "Sports Bars", categoryEmoji: "🍺", categoryId: 10, recWeight: 0.732),
                       PlaceCategory(categoryName: "Juice Bars", categoryEmoji: "🥤", categoryId: 11, recWeight: 0.659),
                       PlaceCategory(categoryName: "Shopping", categoryEmoji: "🛍", categoryId: 12, recWeight: 0.232),
                       PlaceCategory(categoryName: "Bakery", categoryEmoji: "🧁", categoryId: 13, recWeight: 0.732),
                       PlaceCategory(categoryName: "Golfing", categoryEmoji: "⛳️", categoryId: 14, recWeight: 0.346),
                       PlaceCategory(categoryName: "Beaches", categoryEmoji: "🏖", categoryId: 15, recWeight: 0.654),
                       PlaceCategory(categoryName: "Aquariums", categoryEmoji: "🐠", categoryId: 16, recWeight: 0.166),
                       PlaceCategory(categoryName: "Concerts", categoryEmoji: "🎤", categoryId: 17, recWeight: 0.433),
                       PlaceCategory(categoryName: "Swimming", categoryEmoji: "🏊‍♂️", categoryId: 18, recWeight: 0.632),
                       PlaceCategory(categoryName: "Bowling", categoryEmoji: "🎳", categoryId: 19, recWeight: 0.832),
                       PlaceCategory(categoryName: "Pool Halls", categoryEmoji: "🎱", categoryId: 20, recWeight: 0.426),
                       PlaceCategory(categoryName: "Skating", categoryEmoji: "⛸", categoryId: 21, recWeight: 0.736),
                       PlaceCategory(categoryName: "Skate Parks", categoryEmoji: "🛹", categoryId: 22, recWeight: 0.561),
                       PlaceCategory(categoryName: "Mexican Restaurants", categoryEmoji: "🌮", categoryId: 23, recWeight: 0.442),
                       PlaceCategory(categoryName: "Salad Spots", categoryEmoji: "🥗", categoryId: 24, recWeight: 0.523),
                       PlaceCategory(categoryName: "Clubs", categoryEmoji: "🍾", categoryId: 25, recWeight: 0.844),
                       PlaceCategory(categoryName: "Arcades", categoryEmoji: "🕹", categoryId: 26, recWeight: 0.133),
                       PlaceCategory(categoryName: "Camping Spots", categoryEmoji: "⛺️", categoryId: 27, recWeight: 0.345),
                       PlaceCategory(categoryName: "Hotels", categoryEmoji: "🏨", categoryId: 28, recWeight: 0.542),
                       PlaceCategory(categoryName: "Ice Cream", categoryEmoji: "🍦", categoryId: 29, recWeight: 0.214),
                       PlaceCategory(categoryName: "Coffee Shops", categoryEmoji: "☕️", categoryId: 30, recWeight: 0.876),
                       PlaceCategory(categoryName: "Grocery Stores", categoryEmoji: "🛒", categoryId: 31, recWeight: 0.325)]

struct PlaceCategory {
    var categoryName: String
    var categoryEmoji: String
    var categoryId: Int
    var recWeight: Double
}
