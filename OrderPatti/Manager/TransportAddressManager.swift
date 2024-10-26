//
//  TransportAddressManager.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 28/09/24.
//

import Foundation
import FirebaseFirestore
import Combine

protocol TransportAddressManager {
    var  transportListUpdates: AnyPublisher<[Address]?, APIError> { get }
    func createTransport(address: Address) async throws
    func getTransportList() async throws -> [Address]
    func getTransport(id: String) async throws -> Address
    func updateTransport(address: Address) async throws
    func deleteTransport(addressId: String) async throws
}

final class TransportAddressManagerImpl: TransportAddressManager {
    static var shared = TransportAddressManagerImpl()
    private init() {
        observeCompanyList()
    }
    
    private let transportCollection = Firestore.firestore().collection("transportAddress")
    private var listener: ListenerRegistration?
    private let transportListPublisher = CurrentValueSubject<[Address]?, APIError>(nil)
    
    var transportListUpdates: AnyPublisher<[Address]?, APIError> {
        return transportListPublisher.eraseToAnyPublisher()
    }
    
    private func transportDocument(addressId: String) -> DocumentReference {
        transportCollection.document(addressId)
    }
    
    func createTransport(address: Address) async throws {
        let document = transportCollection.document()
        let address = Address(id: document.documentID, address1: address.address1, area: address.area, city: address.city, state: address.state, country: address.country, pincode: address.pincode, cordinates: address.cordinates)
        try document.setData(from: address, merge: false)
    }
    
    func getTransport(id: String) async throws -> Address {
        try await transportDocument(addressId: id).getDocument(as: Address.self)
    }
    
    func deleteTransport(addressId: String) async throws {
        try await transportDocument(addressId: addressId).delete()
    }
    
    func updateTransport(address: Address) async throws {
        try transportDocument(addressId: address.id).setData(from: address, merge: true)
    }
    
    private func getAlltransportQuery() -> Query {
        transportCollection
    }
    
    private func getAllCompanySortedByName(descending: Bool) -> Query {
        transportCollection
            .order(by: Address.CodingKeys.address1.rawValue, descending: descending)
    }
    
    func getTransportList() async throws -> [Address] {
        return try await getAlltransportQuery().getAllDocuments()
    }
    
    private func observeCompanyList() {
        let companyStream = transportCollection.addSnapshotStream(as: [Address].self) { listener in
            self.listener = listener
        }
        Task {
            do {
                for try await companylist in companyStream {
                    transportListPublisher.send(companylist)
                }
            } catch {
                transportListPublisher.send(completion: .failure(.uploadFailed))
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
