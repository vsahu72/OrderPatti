//
//  ProductManager.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 22/09/24.
//

import Foundation
import FirebaseFirestore
import Combine

protocol ProductManager {
    var productListUpdates: AnyPublisher<[Product]?, APIError> { get }
    func createProduct(product: Product) async throws
    func getProductList() async throws -> [Product]
    func getProduct(productId: String) async throws -> Product
    func updateProduct(product: Product) async throws
    func deleteProduct(productId: String) async throws
}

final class ProductManagerImpl: ProductManager {
    
    static var shared = ProductManagerImpl()
    private init() {
        observeProductList()
    }
    
    private let productCollection = Firestore.firestore().collection("product")
    private var listener: ListenerRegistration?
    private let productListPublisher = CurrentValueSubject<[Product]?, APIError>(nil)
    
    var productListUpdates: AnyPublisher<[Product]?, APIError> {
        return productListPublisher.eraseToAnyPublisher()
    }
    
    private func productDocument(productId: String) -> DocumentReference {
        productCollection.document(productId)
    }
    
    func createProduct(product: Product) async throws {
        let document = productCollection.document()
        let newProduct = Product(id: document.documentID, companyID: product.companyID, name: product.name, shortName: product.shortName, unit: product.unit, mrp: product.mrp)
        try document.setData(from: newProduct, merge: false)
    }
    
    func getProduct(productId: String) async throws -> Product {
        try await productDocument(productId: productId).getDocument(as: Product.self)
    }
    
    func deleteProduct(productId: String) async throws {
        try await productDocument(productId: productId).delete()
    }
    
    func updateProduct(product: Product) async throws {
        try productDocument(productId: product.id).setData(from: product, merge: true)
    }
    
    private func getAllProductQuery() -> Query {
        productCollection
    }
    
    private func getAllProductSortedByName(descending: Bool) -> Query {
        productCollection
            .order(by: Product.CodingKeys.name.rawValue, descending: descending)
    }
    
    func getProductList() async throws -> [Product] {
        return try await getAllProductQuery().getAllDocuments()
    }
    
    private func observeProductList() {
        let productStream = productCollection.addSnapshotStream(as: [Product].self) { listener in
            self.listener = listener
        }
        Task {
            do {
                for try await productlist in productStream {
                    productListPublisher.send(productlist)
                }
            } catch {
                productListPublisher.send(completion: .failure(.uploadFailed))
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
