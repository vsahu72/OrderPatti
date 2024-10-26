//
//  OrderManager.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 30/09/24.
//

import Foundation
import FirebaseFirestore
import Combine


protocol OrderDetailsManager {
    var orderDetailsListUpdates: AnyPublisher<[OrderDetails]?, APIError> { get }
    var primaryOrderDetailsUpdate: AnyPublisher<OrderDetails?, APIError> { get }
    func createOrderDetails(orderDetails: OrderDetails) async throws
    func getOrderDetailsList() async throws -> [OrderDetails]
    func getOrderDetails(orderDetailsId: String) async throws -> OrderDetails
    func observeOrderDetails(forOrderId orderDetailsId: String)
    func updateOrderDetails(orderDetails: OrderDetails) async throws
    func resetPrimaryOrderDetails()
    func deleteOrderDetails(orderDetailsId: String) async throws
    func observeOrderDetailsList(for deliveryDate: Date)
}

final class OrderDetailsManagerImpl: OrderDetailsManager {
    
    static var shared = OrderDetailsManagerImpl()
    private init() {
        observeOrderDetailsList(for: Date().onlyDate)
    }
    
    private let orderDetailsCollection = Firestore.firestore().collection("orderDetails")
    private var listener: ListenerRegistration?
    private let orderDetailsListPublisher = CurrentValueSubject<[OrderDetails]?, APIError>(nil)
    private let primaryOrderDetails = CurrentValueSubject<OrderDetails?, APIError>(nil)
    
    var orderDetailsListUpdates: AnyPublisher<[OrderDetails]?, APIError> {
        return orderDetailsListPublisher.eraseToAnyPublisher()
    }
    
    var primaryOrderDetailsUpdate: AnyPublisher<OrderDetails?, APIError> {
        return primaryOrderDetails.eraseToAnyPublisher()
    }
    
    private func orderDetailsDocument(orderDetailsId: String) -> DocumentReference {
        orderDetailsCollection.document(orderDetailsId)
    }
    
    func createOrderDetails(orderDetails: OrderDetails) async throws {
        let document = orderDetailsCollection.document()
        let newOrderDetails = orderDetails.getUpdatedOrderDetailsBy(documentId: document.documentID)
        try document.setData(from: newOrderDetails, merge: false)
    }
    
    func getOrderDetails(orderDetailsId: String) async throws -> OrderDetails {
        try await orderDetailsDocument(orderDetailsId: orderDetailsId).getDocument(as: OrderDetails.self)
    }
    
    func deleteOrderDetails(orderDetailsId: String) async throws {
        try await orderDetailsDocument(orderDetailsId: orderDetailsId).delete()
    }
    
    func observeOrderDetails(forOrderId orderDetailsId: String) {
        Task {
            do {
                let data = try await orderDetailsDocument(orderDetailsId: orderDetailsId).getDocument(as: OrderDetails.self)
                primaryOrderDetails.send(data)
            } catch {
                primaryOrderDetails.send(completion: .failure(.somthingWentWrong))
            }
        }
       
    }
    
    func resetPrimaryOrderDetails() {
        primaryOrderDetails.send(nil)
    }
    
    func updateOrderDetails(orderDetails: OrderDetails) async throws {
        try orderDetailsDocument(orderDetailsId: orderDetails.id).setData(from: orderDetails, merge: true)
    }
    
    private func getAllOrderDetailsQuery() -> Query {
        orderDetailsCollection
    }
    
    private func getAllOrderDetailsSortedByName(descending: Bool) -> Query {
        orderDetailsCollection
            .order(by: OrderDetails.CodingKeys.createdDate.rawValue, descending: descending)
    }
    
    func getOrderDetailsList() async throws -> [OrderDetails] {
        return try await getAllOrderDetailsQuery().getAllDocuments()
    }
    
    private func observeOrderDetailsList() {
        let orderDetailsStream = orderDetailsCollection.addSnapshotStream(as: [OrderDetails].self) { listener in
            self.listener = listener
        }
        Task {
            do {
                for try await orderDetailslist in orderDetailsStream {
                    orderDetailsListPublisher.send(orderDetailslist)
                }
            } catch {
                orderDetailsListPublisher.send(completion: .failure(.uploadFailed))
            }
        }
    }
    
    func observeOrderDetailsList(for deliveryDate: Date) {
        // Assuming `orderDetailsCollection` is a reference to your Firestore collection
        let orderDetailsQuery = orderDetailsCollection
            .whereField("delivery_date", isEqualTo: deliveryDate)

        let orderDetailsStream = orderDetailsQuery.addSnapshotStream(as: [OrderDetails].self) { listener in
            self.listener = listener
        }
        
        Task {
            do {
                for try await orderDetailsList in orderDetailsStream {
                    // Send the filtered order details list to the publisher
                    orderDetailsListPublisher.send(orderDetailsList)
                }
            } catch {
                orderDetailsListPublisher.send(completion: .failure(.uploadFailed))
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
