//
//  BankInfo.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import Foundation

struct BankInfo: Codable, Identifiable, Hashable {
    let id: String?
    let bankName: String?
    let accountNumber: String?
    let ifscCode: String?
    let accountType: String?
    
    init(
        id: String,
        bankName: String? = nil,
        accountNumber: String? = nil,
        ifscCode: String? = nil,
        accountType: String? = nil
    ) {
        self.id = id
        self.bankName = bankName
        self.accountNumber = accountNumber
        self.ifscCode = ifscCode
        self.accountType = accountType
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.bankName = try container.decodeIfPresent(String.self, forKey: .bankName)
        self.accountNumber = try container.decodeIfPresent(String.self, forKey: .accountNumber)
        self.ifscCode = try container.decodeIfPresent(String.self, forKey: .ifscCode)
        self.accountType = try container.decodeIfPresent(String.self, forKey: .accountType)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case bankName = "bank_name"
        case accountNumber = "account_number"
        case ifscCode = "ifsc_code"
        case accountType = "account_type"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.bankName, forKey: .bankName)
        try container.encodeIfPresent(self.accountNumber, forKey: .accountNumber)
        try container.encodeIfPresent(self.ifscCode, forKey: .ifscCode)
        try container.encodeIfPresent(self.accountType, forKey: .accountType)
    }
    
    static func == (lhs: BankInfo, rhs: BankInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
