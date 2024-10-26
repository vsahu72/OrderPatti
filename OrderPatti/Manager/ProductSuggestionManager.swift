//
//  productSuggestionManager.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 23/09/24.
//

import Foundation
import FirebaseFirestore
import Combine

protocol ProductSuggestionManager {
    var productSuggestionListUpdates: AnyPublisher<[ProductSuggestion]?, APIError> { get }
    func createproductSuggestion(productSuggestion: ProductSuggestion) async throws
    func getproductSuggestionList() async throws -> [ProductSuggestion]
    func getproductSuggestion(productSuggestionId: String) async throws -> ProductSuggestion
    func updateproductSuggestion(productSuggestion: ProductSuggestion) async throws
    func deleteProductSuggestion(productSuggestionId: String) async throws
}

final class ProductSuggestionManagerImpl: ProductSuggestionManager {
  
    
    
    static var shared = ProductSuggestionManagerImpl()
    private init() {
        observeproductSuggestionList()
    }
    
    private let productSuggestionCollection = Firestore.firestore().collection("productSuggestion")
    private var listener: ListenerRegistration?
    private let productSuggestionListPublisher = CurrentValueSubject<[ProductSuggestion]?, APIError>(nil)
    
    var productSuggestionListUpdates: AnyPublisher<[ProductSuggestion]?, APIError> {
        return productSuggestionListPublisher.eraseToAnyPublisher()
    }
    
    private func productSuggestionDocument(productSuggestionId: String) -> DocumentReference {
        productSuggestionCollection.document(productSuggestionId)
    }
    
    func createproductSuggestion(productSuggestion: ProductSuggestion) async throws {
        let document = productSuggestionCollection.document()
        let newproductSuggestion = ProductSuggestion(id: document.documentID, productId: productSuggestion.productId, quantity: productSuggestion.quantity, priority: productSuggestion.priority)
        try document.setData(from: newproductSuggestion, merge: false)
    }
    
    func getproductSuggestion(productSuggestionId: String) async throws -> ProductSuggestion {
        try await productSuggestionDocument(productSuggestionId: productSuggestionId).getDocument(as: ProductSuggestion.self)
    }
    
    func deleteProductSuggestion(productSuggestionId: String) async throws {
        try await productSuggestionDocument(productSuggestionId: productSuggestionId).delete()
    }
    
    func updateproductSuggestion(productSuggestion: ProductSuggestion) async throws {
        try productSuggestionDocument(productSuggestionId: productSuggestion.id).setData(from: productSuggestion, merge: true)
    }
    
    private func getAllProductSuggestionQuery() -> Query {
        productSuggestionCollection
    }
    
    private func getAllproductSuggestionSortedByPriority(descending: Bool) -> Query {
        productSuggestionCollection
            .order(by: ProductSuggestion.CodingKeys.priority.rawValue, descending: descending)
    }
    
    func getproductSuggestionList() async throws -> [ProductSuggestion] {
        return try await getAllProductSuggestionQuery().getAllDocuments()
    }
    
    private func observeproductSuggestionList() {
        let productSuggestionStream = productSuggestionCollection.addSnapshotStream(as: [ProductSuggestion].self) { listener in
            self.listener = listener
        }
        Task {
            do {
                for try await productSuggestionlist in productSuggestionStream {
                    productSuggestionListPublisher.send(productSuggestionlist)
                }
            } catch {
                productSuggestionListPublisher.send(completion: .failure(.uploadFailed))
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
