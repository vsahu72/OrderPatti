//
//  Company.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import Foundation

struct Company: Codable, Identifiable, IdentifiableByString, Hashable {
    
    let id: String
    let createdDate: Date?
    let modifiedDate: Date?
    let name: String?
    let gstNumber: String?
    let address: Address?
    let bankInfo: BankInfo?
    
    init(
        id: String,
        createdDate: Date? = nil,
        modifiedDate: Date? = nil,
        name: String? = nil,
        gstNumber: String? = nil,
        address: Address? = nil,
        bankInfo: BankInfo? = nil
    ) {
        self.id = id
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.name = name
        self.gstNumber = gstNumber
        self.address = address
        self.bankInfo = bankInfo
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdDate = "created_date"
        case modifiedDate = "modified_date"
        case name = "name"
        case gstNumber = "gst_number"
        case address = "address"
        case bankInfo = "bank_info"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.createdDate = try container.decodeIfPresent(Date.self, forKey: .createdDate)
        self.modifiedDate = try container.decodeIfPresent(Date.self, forKey: .modifiedDate)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.gstNumber = try container.decodeIfPresent(String.self, forKey: .gstNumber)
        self.address = try container.decodeIfPresent(Address.self, forKey: .address)
        self.bankInfo = try container.decodeIfPresent(BankInfo.self, forKey: .bankInfo)
    }
     
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.createdDate, forKey: .createdDate)
        try container.encodeIfPresent(self.modifiedDate, forKey: .modifiedDate)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.gstNumber, forKey: .gstNumber)
        try container.encodeIfPresent(self.address, forKey: .address)
        try container.encodeIfPresent(self.bankInfo, forKey: .bankInfo)
    }
    
    static func == (lhs: Company, rhs: Company) -> Bool {
        return lhs.id == rhs.id
    }
}
