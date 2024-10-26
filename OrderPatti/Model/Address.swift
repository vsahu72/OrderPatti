//
//  Address.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import Foundation

struct Address: Codable, Identifiable, Hashable, IdentifiableByString {
    let id: String
    var address1: String?
    let area: String?
    var city: String?
    let state: String?
    let country: String?
    let pincode: String?
    let cordinates: String?
    
    init(
        id: String,
        address1: String? = nil,
        area: String? = nil,
        city: String? = nil,
        state: String? = nil,
        country: String? = nil,
        pincode: String? = nil,
        cordinates: String? = nil
    ) {
        self.id = id
        self.address1 = address1
        self.area = area
        self.city = city
        self.state = state
        self.country = country
        self.pincode = pincode
        self.cordinates = cordinates
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.address1 = try container.decodeIfPresent(String.self, forKey: .address1)
        self.area = try container.decodeIfPresent(String.self, forKey: .area)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.pincode = try container.decodeIfPresent(String.self, forKey: .pincode)
        self.cordinates = try container.decodeIfPresent(String.self, forKey: .cordinates)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case address1
        case area
        case city
        case state
        case country
        case pincode
        case cordinates
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.address1, forKey: .address1)
        try container.encodeIfPresent(self.area, forKey: .area)
        try container.encodeIfPresent(self.city, forKey: .city)
        try container.encodeIfPresent(self.state, forKey: .state)
        try container.encodeIfPresent(self.country, forKey: .country)
        try container.encodeIfPresent(self.pincode, forKey: .pincode)
        try container.encodeIfPresent(self.cordinates, forKey: .cordinates)
    }
    
    static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.id == rhs.id
    }
}
