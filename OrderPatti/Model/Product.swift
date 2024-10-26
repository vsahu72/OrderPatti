//
//  Product.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 10/09/24.
//

import Foundation

struct ProductSuggestion: Codable, Identifiable, IdentifiableByString, Hashable {
    var id: String
    var productId: String?
    var quantity: Int?
    var priority: Int?
    
    init(id: String, 
         productId: String?,
         quantity: Int?,
         priority: Int?
    ) {
        self.id = id
        self.productId = productId
        self.quantity = quantity
        self.priority = priority
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case quantity
        case priority
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        self.priority = try container.decodeIfPresent(Int.self, forKey: .priority)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.quantity, forKey: .quantity)
        try container.encodeIfPresent(self.priority, forKey: .priority)
    }
}

struct Product: Codable, Identifiable, IdentifiableByString, Hashable, Equatable {
    var id: String
    var companyID: String?
    var name: String?
    var shortName: String?
    var unit: String?
    var mrp: Decimal?
    
    init(id: String,
         companyID: String? = nil,
         name: String? = nil,
         shortName: String? = nil,
         unit: String? = nil,
         mrp: Decimal? = nil
    ) {
        self.id = id
        self.companyID = companyID
        self.name = name
        self.shortName = shortName
        self.unit = unit
        self.mrp = mrp
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case companyID = "company_id"
        case name = "name"
        case shortName = "short_name"
        case mrp = "mrp"
        case unit = "unit"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.companyID = try container.decodeIfPresent(String.self, forKey: .companyID)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.shortName = try container.decodeIfPresent(String.self, forKey: .shortName)
        self.mrp = try container.decodeIfPresent(Decimal.self, forKey: .mrp)
        self.unit = try container.decodeIfPresent(String.self, forKey: .unit)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.companyID, forKey: .companyID)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.shortName, forKey: .shortName)
        try container.encodeIfPresent(self.mrp, forKey: .mrp)
        try container.encodeIfPresent(self.unit, forKey: .unit)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id // Compare by ID, or adjust as necessary
    }
}
