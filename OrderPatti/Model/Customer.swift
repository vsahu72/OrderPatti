//
//  Customer.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 10/09/24.
//

import Foundation

struct Customer: Codable, Identifiable, IdentifiableByString, Hashable {
    var id: String
    let createdDate: Date?
    let modifiedDate: Date?
    var companyId: String?
    var name: String?
    var gstNumber: String?
    var address: Address?
    var bankInfo: BankInfo?
    var products: [CustomerProduct]?
    
    init(id: String, 
         createdDate: Date?,
         modifiedDate: Date?, 
         companyId: String? = nil,
         name: String? = nil,
         gstNumber: String? = nil,
         address: Address? = nil,
         bankInfo: BankInfo? = nil,
         products: [CustomerProduct]? = nil
    ) {
        self.id = id
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.companyId = companyId
        self.name = name
        self.gstNumber = gstNumber
        self.address = address
        self.bankInfo = bankInfo
        self.products = products
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdDate = "created_date"
        case modifiedDate = "modified_date"
        case companyId = "company_id"
        case name
        case gstNumber = "gst_number"
        case address
        case bankInfo = "bank_info"
        case products
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.createdDate, forKey: .createdDate)
        try container.encodeIfPresent(self.modifiedDate, forKey: .modifiedDate)
        try container.encodeIfPresent(self.companyId, forKey: .companyId)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.gstNumber, forKey: .gstNumber)
        try container.encodeIfPresent(self.address, forKey: .address)
        try container.encodeIfPresent(self.bankInfo, forKey: .bankInfo)
        try container.encodeIfPresent(self.products, forKey: .products)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.createdDate = try container.decodeIfPresent(Date.self, forKey: .createdDate)
        self.modifiedDate = try container.decodeIfPresent(Date.self, forKey: .modifiedDate)
        self.companyId = try container.decodeIfPresent(String.self, forKey: .companyId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.gstNumber = try container.decodeIfPresent(String.self, forKey: .gstNumber)
        self.address = try container.decodeIfPresent(Address.self, forKey: .address)
        self.bankInfo = try container.decodeIfPresent(BankInfo.self, forKey: .bankInfo)
        self.products = try container.decodeIfPresent([CustomerProduct].self, forKey: .products)
    }
    
    static func == (lhs: Customer, rhs: Customer) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CustomerProduct: Codable, Hashable {
    var id: String
    var productId: String?
    var discountedPrice: Decimal?
    
    init(id: String,
         productId: String? = nil,
         discountedPrice: Decimal? = nil
    ) {
        self.id = id
        self.productId = productId
        self.discountedPrice = discountedPrice
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.discountedPrice = try container.decodeIfPresent(Decimal.self, forKey: .discountedPrice)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId
        case discountedPrice
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.discountedPrice, forKey: .discountedPrice)
    }
    
    static func == (lhs: CustomerProduct, rhs: CustomerProduct) -> Bool {
        return lhs.id == rhs.id
    }
}
