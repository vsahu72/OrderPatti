//
//  CustomerManager.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 28/09/24.
//

import Foundation
import FirebaseFirestore
import Combine

protocol CustomerManager {
    var  customerListUpdates: AnyPublisher<[Customer]?, APIError> { get }
    func createCustomer(customer: Customer) async throws
    func getCustomerList() async throws -> [Customer]
    func getCustomer(customerId: String) async throws -> Customer
    func updateCustomer(customer: Customer) async throws
    func deleteCustomer(customerId: String) async throws
}

final class CustomerManagerImpl: CustomerManager {
    
    static var shared = CustomerManagerImpl()
    private init() {
        observeCustomerList()
    }
    
    private let customerCollection = Firestore.firestore().collection("customer")
    private var listener: ListenerRegistration?
    private let customerListPublisher = CurrentValueSubject<[Customer]?, APIError>(nil)
    
    var customerListUpdates: AnyPublisher<[Customer]?, APIError> {
        return customerListPublisher.eraseToAnyPublisher()
    }
    
    private func customerDocument(customerId: String) -> DocumentReference {
        customerCollection.document(customerId)
    }
    
    func createCustomer(customer: Customer) async throws {
        let document = customerCollection.document()
        let newcustomer = Customer(id: document.documentID, createdDate: customer.createdDate, modifiedDate: Date(), companyId: customer.companyId, name: customer.name, gstNumber: customer.gstNumber, address: customer.address, bankInfo: customer.bankInfo, products: customer.products)
        try document.setData(from: newcustomer, merge: false)
    }
    
    func getCustomer(customerId: String) async throws -> Customer {
        try await customerDocument(customerId: customerId).getDocument(as: Customer.self)
    }
    
    func deleteCustomer(customerId: String) async throws {
        try await customerDocument(customerId: customerId).delete()
    }
    
    func updateCustomer(customer: Customer) async throws {
        try customerDocument(customerId: customer.id).setData(from: customer, merge: true)
    }
    
    private func getAllCustomerQuery() -> Query {
        customerCollection
    }
    
    private func getAllCustomerSortedByName(descending: Bool) -> Query {
        customerCollection
            .order(by: Customer.CodingKeys.name.rawValue, descending: descending)
    }
    
    func getCustomerList() async throws -> [Customer] {
        return try await getAllCustomerQuery().getAllDocuments()
    }
    
    private func observeCustomerList() {
        let customerStream = customerCollection.addSnapshotStream(as: [Customer].self) { listener in
            self.listener = listener
        }
        Task {
            do {
                for try await customerlist in customerStream {
                    customerListPublisher.send(customerlist)
                }
            } catch {
                customerListPublisher.send(completion: .failure(.uploadFailed))
            }
        }
    }
    
    private func stopListening() {
        listener?.remove()
    }
    
    deinit {
        stopListening()
    }
}
