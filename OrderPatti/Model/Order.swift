//
//  Order.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 10/09/24.
//

import Foundation

struct OrderDetails: Codable, Identifiable, Hashable, IdentifiableByString {
    var id: String
    var createdDate: Date?
    var modifiedDate: Date?
    var deliveryDate: Date?
    var companyId: String?
    var companyName: String?
    var customerId: String?
    var customerName: String?
    var customerAddress: String?
    var items: [OrderItem]?
    var totalPrice: Decimal?
    var totalDiscountedPrice: Decimal?
    var transportAddressId: String?
    var transportAddress: String?
    var orderStatus: String?
    var biltyNumber: String?
    
    init(id: String, 
         createdDate: Date? = nil,
         modifiedDate: Date? = nil,
         deliveryDate: Date? = nil,
         companyId: String? = nil,
         companyName: String? = nil,
         customerId: String? = nil,
         customerName: String? = nil,
         customerAddress: String? = nil,
         items: [OrderItem]? = nil,
         totalPrice: Decimal? = nil,
         totalDiscountedPrice: Decimal? = nil,
         transportAddressId: String? = nil,
         transportAddress: String? = nil,
         orderStatus: String? = nil,
         biltyNumber: String? = nil
    ) {
        self.id = id
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.deliveryDate = deliveryDate
        self.companyId = companyId
        self.companyName = companyName
        self.customerId = customerId
        self.customerName = customerName
        self.customerAddress = customerAddress
        self.items = items
        self.totalPrice = totalPrice
        self.totalDiscountedPrice = totalDiscountedPrice
        self.transportAddressId = transportAddressId
        self.transportAddress = transportAddress
        self.orderStatus = orderStatus
        self.biltyNumber = biltyNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdDate = "created_date"
        case modifiedDate = "modified_date"
        case deliveryDate = "delivery_date"
        case companyId = "company_id"
        case companyName = "company_name"
        case customerId = "customer_id"
        case customerName = "customer_name"
        case customerAddress = "customer_address"
        case items
        case totalPrice = "total_price"
        case totalDiscountedPrice = "total_discounted_price"
        case transportAddressId = "transport_address_id"
        case transportAddress = "transport_address"
        case orderStatus = "order_status"
        case biltyNumber = "bilty_number"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.createdDate = try container.decodeIfPresent(Date.self, forKey: .createdDate)
        self.modifiedDate = try container.decodeIfPresent(Date.self, forKey: .modifiedDate)
        self.deliveryDate = try container.decodeIfPresent(Date.self, forKey: .deliveryDate)
        self.companyId = try container.decodeIfPresent(String.self, forKey: .companyId)
        self.companyName = try container.decodeIfPresent(String.self, forKey: .companyName)
        self.customerId = try container.decodeIfPresent(String.self, forKey: .customerId)
        self.customerName = try container.decodeIfPresent(String.self, forKey: .customerName)
        self.customerAddress = try container.decodeIfPresent(String.self, forKey: .customerAddress)
        self.items = try container.decodeIfPresent([OrderItem].self, forKey: .items)
        self.totalPrice = try container.decodeIfPresent(Decimal.self, forKey: .totalPrice)
        self.totalDiscountedPrice = try container.decodeIfPresent(Decimal.self, forKey: .totalDiscountedPrice)
        self.transportAddressId = try container.decodeIfPresent(String.self, forKey: .transportAddressId)
        self.transportAddress = try container.decodeIfPresent(String.self, forKey: .transportAddress)
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus)
        self.biltyNumber = try container.decodeIfPresent(String.self, forKey: .biltyNumber)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.createdDate, forKey: .createdDate)
        try container.encodeIfPresent(self.modifiedDate, forKey: .modifiedDate)
        try container.encodeIfPresent(self.deliveryDate, forKey: .deliveryDate)
        try container.encodeIfPresent(self.companyId, forKey: .customerId)
        try container.encodeIfPresent(self.companyName, forKey: .companyName)
        try container.encodeIfPresent(self.customerId, forKey: .customerId)
        try container.encodeIfPresent(self.customerName, forKey: .customerName)
        try container.encodeIfPresent(self.customerAddress, forKey: .customerAddress)
        try container.encodeIfPresent(self.items, forKey: .items)
        try container.encodeIfPresent(self.totalPrice, forKey: .totalPrice)
        try container.encodeIfPresent(self.totalDiscountedPrice, forKey: .totalDiscountedPrice)
        try container.encodeIfPresent(self.transportAddressId, forKey: .transportAddressId)
        try container.encodeIfPresent(self.transportAddress, forKey: .transportAddress)
        try container.encodeIfPresent(self.orderStatus, forKey: .orderStatus)
        try container.encodeIfPresent(self.biltyNumber, forKey: .biltyNumber)
    }
    
    func getUpdatedOrderDetailsBy(documentId: String) -> OrderDetails {
        var orderDetails = OrderDetails(id: documentId)
        orderDetails.createdDate = createdDate
        orderDetails.modifiedDate = Date()
        orderDetails.deliveryDate = deliveryDate
        orderDetails.companyId = companyId
        orderDetails.companyName = companyName
        orderDetails.customerId = customerId
        orderDetails.customerName = customerName
        orderDetails.customerAddress = customerAddress
        orderDetails.items = items
        orderDetails.totalPrice = totalPrice
        orderDetails.totalDiscountedPrice = totalDiscountedPrice
        orderDetails.transportAddressId = transportAddressId
        orderDetails.transportAddress = transportAddress
        orderDetails.orderStatus = orderStatus
        orderDetails.biltyNumber = biltyNumber
        return orderDetails
    }
}

struct OrderItem: Codable, Identifiable, Hashable, IdentifiableByString {
    var id: String
    var productId: String?
    var productName: String?
    var quantity: Int?
    var rate: Decimal?
    var unit: String?
    var discountedRate: Decimal?
    var orderItemStatus: String?
    
    func totalPrice() -> Decimal {
        return (rate ?? 0) * Decimal(quantity ?? 0)
    }
    
    func totalDiscoutedPrice() -> Decimal {
        let rate = discountedRate ?? (rate ?? 0)
        return rate * Decimal(quantity ?? 0)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case productName = "product_name"
        case quantity
        case unit
        case rate
        case discountedRate = "discounted_rate"
        case orderItemStatus = "order_item_status"
    }

    init(id: String,
         productId: String? = nil,
         productName: String? = nil,
         unit: String? = nil,
         quantity: Int? = nil,
         rate: Decimal? = nil,
         discountedRate: Decimal? = nil,
         orderItemStatus: String? = nil
    ) {
        self.id = id
        self.productId = productId
        self.productName = productName
        self.unit = unit
        self.quantity = quantity
        self.rate = rate
        self.discountedRate = discountedRate
        self.orderItemStatus = orderItemStatus
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.unit = try container.decodeIfPresent(String.self, forKey: .unit)
        self.productName = try container.decodeIfPresent(String.self, forKey: .productName)
        self.quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        self.rate = try container.decodeIfPresent(Decimal.self, forKey: .rate)
        self.discountedRate = try container.decodeIfPresent(Decimal.self, forKey: .discountedRate)
        self.orderItemStatus = try container.decodeIfPresent(String.self, forKey: .orderItemStatus)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.productId, forKey: .productId)
        try container.encodeIfPresent(self.productName, forKey: .productName)
        try container.encodeIfPresent(self.unit, forKey: .unit)
        try container.encodeIfPresent(self.quantity, forKey: .quantity)
        try container.encodeIfPresent(self.rate, forKey: .rate)
        try container.encodeIfPresent(self.discountedRate, forKey: .discountedRate)
        try container.encodeIfPresent(self.orderItemStatus, forKey: .orderItemStatus)
    }
}
