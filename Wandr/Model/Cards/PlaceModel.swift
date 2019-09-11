
import Foundation
import UIKit

struct PlacesApiResponse {
    let places: [Place]
}

extension PlacesApiResponse: Decodable {
    
    private enum PlacesApiResponseCodingKeys: String, CodingKey {
        case places = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PlacesApiResponseCodingKeys.self)
        places = try container.decode([Place].self, forKey: .places)
    }
}

struct Place: ProducesCardViewModel {
    var id: String
    var name: String
    var rating: CGFloat
    var ratingCount: Int
    let location: Location
    var placeImages: [String]
    var isClosed: Bool
    var distance: Double
    var price: String
    var categories: [[String: String]]
}

extension Place: Decodable {
    
    enum PlaceCodingKeys: String, CodingKey {
        case id
        case name
        case rating
        case price
        case distance
        case cover = "image_url"
        case location
        case ratingCount = "review_count"
        case isClosed = "is_closed"
        case categories
    }
    
    init(from decoder: Decoder) throws {
        let placeContainer = try decoder.container(keyedBy: PlaceCodingKeys.self)
        self.id = try placeContainer.decode(String.self, forKey: .id)
        self.rating = try placeContainer.decode(CGFloat.self, forKey: .rating)
        self.name = try placeContainer.decode(String.self, forKey: .name)
        self.price = try placeContainer.decode(String.self, forKey: .price)
        self.categories = try placeContainer.decode([[String: String]].self, forKey: .categories)
        self.location = try placeContainer.decode(Location.self, forKey: .location)
        self.distance = try placeContainer.decode(Double.self, forKey: .distance) * 0.00062137 //For miles conversion
        self.isClosed = try placeContainer.decode(Bool.self, forKey: .isClosed)
        self.placeImages = [try placeContainer.decode(String.self, forKey: .cover)]
        self.ratingCount = try placeContainer.decode(Int.self, forKey: .ratingCount)
    }
    
    func toCardViewModel() -> CardViewModel {
        return CardViewModel(placeImages: placeImages, headerContent: ["title": name, "distance": "\(distance.truncate(places: 1)) mi"], detailsContent: [["city": "🏡 \(location.city)", "categories": categories[0]["title"]!], ["price": price, "operatingStatus": isClosed ? "Closed" : "Open", "rating": "⭐️ \(rating) (\(ratingCount))"]])
    }
}
