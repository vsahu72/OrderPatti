//
//  MockData.swift
//  OrderDetailsPatti
//
//  Created by Vikash Sahu on 10/09/24.
//

import Foundation


struct MockData {
   
    func getCompneyInfo() -> Company {
        let bankInfo = BankInfo(id: "1", bankName: "Bank of baroda",
                                accountNumber: "123456789012",
                                ifscCode: "BOB1234C0",
                                accountType: "current")
        
        let address = Address(id: "1",address1: "35 Shani gali junni inodre",
                              area: "Junni Inodre",
                              city: "Indore",
                              state: "Madhya Pradesh",
                              country: "India",
                              pincode: "452007",
                              cordinates: "22.719568,75.857727")
        
        return Company(id: "1",name: "Khushbu Sweets", gstNumber: "23AAACH7409R1Z9", address: address, bankInfo: bankInfo)
    }
    
    func getProductList(company: Company) -> [Product] {
        let product1 = Product(id: "1", companyID: company.id, name: "Laddu", mrp: 30.00)
        
        let product2 = Product(id: "2",companyID: company.id, name: "Peda", mrp: 40.00)
        let product3 = Product(id: "3",companyID: company.id, name: "Barfi", mrp: 50.00)
        let product4 = Product(id: "4",companyID: company.id, name: "Start Milk Barfi Jar", mrp: 34.00)
        let product5 = Product(id: "5",companyID: company.id, name: "Star Milk Barfi Jar 100 Nag", mrp: 330.00)
        let product6 = Product(id: "6",companyID: company.id, name: "Star Milk Barfi Jar 75 Nag", mrp: 130.00)
        let product7 = Product(id: "7",companyID: company.id, name: "Star Milk Barfi Jar 120 Nag", mrp: 34.00)
        let product8 = Product(id: "8",companyID: company.id, name: "Star Milk Barfi Jar 5 Rupee", mrp: 55.00)
        let product9 = Product(id: "9",companyID: company.id, name: "Star Milk Barfi Jar 1 Rupee", mrp: 65.00)
        let product10 = Product(id: "10",companyID: company.id, name: "Star Milk Barfi Jar 2 Rupee", mrp: 56.00)
        return [product1, product2, product3, product4, product5, product6, product7, product8, product9, product10]
    }
    
    func getCustomer(company: Company, products: [Product]) -> [Customer] {
        let customer1 = getCustomer1(company: company, products: products)
        let customer2 = getCustomer2(company: company, products: products)
        let customer3 = Customer(id: "1", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Jitendra Shop", address: Address(id: "1", city: "Indore"))
        let customer4 = Customer(id: "2", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Sanskar Shop", address: Address(id: "2", city: "Indore"))
        let customer5 = Customer(id: "3", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Sagar Shop", address: Address(id: "3", city: "Indore"))
        let customer6 = Customer(id: "4",  createdDate: Date(), modifiedDate: Date(),companyId: company.id, name: "Vishal Shop", address: Address(id: "4", city: "Indore"))
        let customer7 = Customer(id: "5", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Umesh Shop", address: Address(id: "5", city: "Indore"))
        let customer8 = Customer(id: "6", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Sanjit Shop", address: Address(id: "6", city: "Indore"))
        let customer9 = Customer(id: "7", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Aditya Shop", address: Address(id: "7", city: "Indore"))
        let customer10 = Customer(id: "8", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Amit Shop", address: Address(id: "8", city: "Indore"))
        let customer11 = Customer(id: "9", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Tarun Shop", address: Address(id: "9", city: "Indore"))
        let customer12 = Customer(id: "10",  createdDate: Date(), modifiedDate: Date(),companyId: company.id, name: "Dolly Shop", address: Address(id: "10", city: "Indore"))
        let customer13 = Customer(id: "11", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Anita Shop", address: Address(id: "11", city: "Indore"))
        let customer14 = Customer(id: "12", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Arun Confectionary", address: Address(id: "12", city: "Indore"))
        let customer15 = Customer(id: "13", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Aarav Shop", address: Address(id: "13", city: "Indore"))
        let customer16 = Customer(id: "14", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Sudhanshu Shop", address: Address(id: "14", city: "Indore"))
        let customer17 = Customer(id: "15", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Mahesh Shop", address: Address(id: "15", city: "Indore"))
        let customer18 = Customer(id: "16", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Bade Shop", address: Address(id: "16", city: "Bhopal"))
        let customer19 = Customer(id: "17", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Chhote Shop", address: Address(id: "17", city: "Gwalior"))
        let customer20 = Customer(id: "18",  createdDate: Date(), modifiedDate: Date(),companyId: company.id, name: "Sweet Shop", address: Address(id: "18", city: "Jabalpur"))
        
       return [customer1, customer2, customer3,customer4,customer5,customer6,customer7,customer8,customer9,customer10,customer11,customer12,customer13,customer14,customer15,customer16,customer17,customer18,customer19,customer20]
    }
    
    func getCustomer1(company: Company, products: [Product]) -> Customer {
        let bankInfo = BankInfo(id: "18", bankName: "Bank of India",
                                accountNumber: "112233445566",
                                ifscCode: "BOI3234C0",
                                accountType: "current")
        
        let address = Address(id: "18", address1: "Ram nagar",
                              area: "Bagoda",
                              city: "Bagodar",
                              state: "Jharkhand",
                              country: "India",
                              pincode: "825322",
                              cordinates: "22.719568,75.857727")
        
//        let laddu = products.first(where: {$0.name == "Laddu"})
//        let product1 = CustomerProduct(product: laddu!, discountedRate: 28)
//        
//        let peda = products.first(where: {$0.name == "Peda"})
//        let product2 = CustomerProduct(product: peda!, discountedRate: 35)
//        
//        let barfi = products.first(where: {$0.name == "Barfi"})
//        let product3 = CustomerProduct(product: barfi!, discountedRate: 55)
//        
//        let startJar = products.first(where: {$0.name == "Start Milk Barfi Jar"})
//        let product4 = CustomerProduct(product: startJar!, discountedRate: 30)
//        
//        let star72nag = products.first(where: {$0.name == "Star Milk Barfi Jar 120 Nag"})
//        let product5 = CustomerProduct(product: star72nag!, discountedRate: 32)
        
        return Customer(id: "1", createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Vikash confectionary", address: address, bankInfo: bankInfo, products: [])
    }
    
    func getCustomer2(company: Company, products: [Product]) -> Customer {
        let bankInfo = BankInfo(id: "18", bankName: "ICICI Bank",
                                accountNumber: "1100222333000344",
                                ifscCode: "ICIC08976T7",
                                accountType: "current")
        
        let address = Address(id: "18", address1: "indore",
                              area: "Siyaganj",
                              city: "Indore",
                              state: "Madhya Pradesh",
                              country: "India",
                              pincode: "452001",
                              cordinates: "22.719568,75.857727")
        
//        let laddu = products.first(where: {$0.name == "Laddu"})
//        let product1 = CustomerProduct(product: laddu!, discountedRate: 27)
//        
//        let peda = products.first(where: {$0.name == "Peda"})
//        let product2 = CustomerProduct(product: peda!, discountedRate: 34)
//        
//        let barfi = products.first(where: {$0.name == "Barfi"})
//        let product3 = CustomerProduct(product: barfi!, discountedRate: 50)
//        
//        let startJar = products.first(where: {$0.name == "Start Milk Barfi Jar"})
//        let product4 = CustomerProduct(product: startJar!, discountedRate: 25)
        
        return Customer(id: "1",  createdDate: Date(), modifiedDate: Date(), companyId: company.id, name: "Amit confectionary", address: address, bankInfo: bankInfo, products: [])
    }
}

extension MockData {
    func getOrderDetails(company: Company,customers: [Customer], products: [Product]) -> [OrderDetails]{
        var orderList: [OrderDetails] = []
        
        for i in 0...15 {
            if i == 0 {
                let customer = customers[i]
                let order = getOrderDetails1(company: company, customer: customer, products: products)
                orderList.append(order)
            }
            if i == 1 {
                let customer = customers[i]
                let order = getOrderDetails2(company: company, customer: customer, products: products)
                orderList.append(order)
            }
            if i == 2 {
                let customer = customers[i]
                let order = getOrderDetails3(company: company, customer: customer, products: products)
                orderList.append(order)
            }
            if i > 2 {
                let customer = customers[i]
                let order = getOrderDetails3(company: company, customer: customer, products: products)
                orderList.append(order)
            }
        }
        return orderList
    }
    
    func getOrderDetails1(company: Company,customer: Customer, products: [Product]) -> OrderDetails {
        let laddu1 = products.first(where: { $0.name == "Laddu"})
        let quantity1 = 120
        let totalPrice1 = getCustomerProductTotalPrice(quantity: quantity1, product: laddu1!, customer: customer)
        let orderProduct1 =  OrderItem(id: "1", productId: "1", productName: "Laddu", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Ready")
        
        let peda = products.first(where: { $0.name == "Peda"})
        let quantity2 = 60
        let totalPrice2 = getCustomerProductTotalPrice(quantity: quantity2, product: peda!, customer: customer)
        let orderProduct2 =  OrderItem(id: "2", productId: "2", productName: "Peda", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Order Placed")
        
        let barfi = products.first(where: { $0.name == "Barfi"})
        let quantity3 = 100
        let totalPrice3 = getCustomerProductTotalPrice(quantity: quantity2, product: barfi!, customer: customer)
        let orderProduct3 =  OrderItem(id: "3", productId: "3", productName: "Barfi", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Deliver")
        
        let star = products.first(where: { $0.name == "Start Milk Barfi Jar"})
        let quantity4 = 240
        let totalPrice4 = getCustomerProductTotalPrice(quantity: quantity4, product: star!, customer: customer)
        let orderProduct4 =  OrderItem(id: "1", productId: "1", productName: "Start Milk Barfi Jar", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Ready")
        
        let orderProducts = [orderProduct1, orderProduct2, orderProduct3, orderProduct4]
        
        let transportAddress = Address(id: "18", address1: "Ashok Transport",
                              area: "Lohamandi",
                              city: "Indore",
                              state: "Madhya Pradesh",
                              country: "India",
                              pincode: "452001",
                              cordinates: "22.719568,75.857727")
        let totalOrderDetailsPrice = orderProducts.reduce(0, { x, y in x + y.totalPrice() })
        return OrderDetails(id: "1", createdDate: Date(), modifiedDate: Date(), companyName: company.name, customerId: customer.id, customerName: customer.name, customerAddress: customer.address?.city, items: orderProducts, totalPrice: totalOrderDetailsPrice, totalDiscountedPrice: totalOrderDetailsPrice, transportAddressId: "1", transportAddress: "Indore", orderStatus: "Ready", biltyNumber: nil)
    }
    
    func getOrderDetails2(company: Company,customer: Customer, products: [Product]) -> OrderDetails {
        let laddu1 = products.first(where: { $0.name == "Laddu"})
        let quantity1 = 200
        let totalPrice1 = getCustomerProductTotalPrice(quantity: quantity1, product: laddu1!, customer: customer)
        let orderProduct1 = OrderItem(id: "1", productId: "1", productName: "Laddu", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Ready")
        
        let peda = products.first(where: { $0.name == "Peda"})
        let quantity2 = 50
        let totalPrice2 = getCustomerProductTotalPrice(quantity: quantity2, product: peda!, customer: customer)
        let orderProduct2 =  OrderItem(id: "2", productId: "2", productName: "Peda", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Ready")
        
        let barfi = products.first(where: { $0.name == "Barfi"})
        let quantity3 = 140
        let totalPrice3 = getCustomerProductTotalPrice(quantity: quantity2, product: barfi!, customer: customer)
        let orderProduct3 =  OrderItem(id: "3", productId: "3", productName: "Barfi", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Ready")
        
        
        let orderProducts = [orderProduct1, orderProduct2, orderProduct3]
        
        let transportAddress = Address(id: "18", address1: "Ashok Transport",
                              area: "Lohamandi",
                              city: "Indore",
                              state: "Madhya Pradesh",
                              country: "India",
                              pincode: "452001",
                              cordinates: "22.719568,75.857727")
        let totalOrderDetailsPrice = orderProducts.reduce(0, { x, y in x + y.totalPrice() })
        return OrderDetails(id: "2", createdDate: Date(), modifiedDate: Date(), companyName: company.name, customerId: customer.id, customerName: customer.name, customerAddress: customer.address?.city, items: orderProducts, totalPrice: totalOrderDetailsPrice, totalDiscountedPrice: totalOrderDetailsPrice, transportAddressId: "1", transportAddress: "Indore", orderStatus: "Ready", biltyNumber: nil)
    }
    
    func getOrderDetails3(company: Company,customer: Customer, products: [Product]) -> OrderDetails {
        let laddu1 = products.first(where: { $0.name == "Laddu"})
        let quantity1 = 240
        let totalPrice1 = getCustomerProductTotalPrice(quantity: quantity1, product: laddu1!, customer: customer)
            let orderProduct1 =  OrderItem(id: "1", productId: "1", productName: "Laddu", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Ready")
        
        let peda = products.first(where: { $0.name == "Peda"})
        let quantity2 = 80
        let totalPrice2 = getCustomerProductTotalPrice(quantity: quantity2, product: peda!, customer: customer)
        let orderProduct2 =  OrderItem(id: "2", productId: "2", productName: "Peda", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Ready")
        
        let barfi = products.first(where: { $0.name == "Barfi"})
        let quantity3 = 120
        let totalPrice3 = getCustomerProductTotalPrice(quantity: quantity2, product: barfi!, customer: customer)
        let orderProduct3 =  OrderItem(id: "3", productId: "3", productName: "Barfi", quantity: quantity1,rate: totalPrice1, discountedRate: totalPrice1, orderItemStatus: "Ready")
        
        
        let orderProducts = [orderProduct1]
        
        let totalOrderDetailsPrice = orderProducts.reduce(0, { x, y in x + y.totalPrice() })
        return OrderDetails(id: "3", createdDate: Date(), modifiedDate: Date(), companyName: company.name, customerId: customer.id, customerName: customer.name, customerAddress: customer.address?.city, items: orderProducts, totalPrice: totalOrderDetailsPrice, totalDiscountedPrice: totalOrderDetailsPrice, transportAddressId: "1", transportAddress: "Indore", orderStatus: "Ready", biltyNumber: nil)
    }
    
    func getCustomerProductTotalPrice(quantity: Int, product: Product, customer: Customer) -> Decimal {
//        let customerProduct = customer.products?.first(where: {$0.product.id == product.id})
//        var totalPrice = Decimal(quantity) * (product.mrp ?? 0.0)
//        if let cusProduct = customerProduct {
//            totalPrice = Decimal(quantity) * cusProduct.discountedRate
//        }
        return 200.30
    }
    
    func getSingleOrderDetails() -> OrderDetails {
        let componayInfo = MockData().getCompneyInfo()
        let productList = MockData().getProductList(company: componayInfo)
        let customerList = MockData().getCustomer(company: componayInfo, products: productList)
        return getOrderDetails1(company: componayInfo, customer: customerList.first!, products: productList)
    }
}
