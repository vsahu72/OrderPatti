//
//  OrderDetailsListViewModel.swift
//  OrderDetailsPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI
import Combine

class OrderDetailsListViewModel: ObservableObject {

    @Published var filterOrderDetailsList: [OrderItemCellViewModel] = []
    @Published var expandedRows: Set<String> = []
    @Published var isAllExpanded: Bool = false
    
    var primaryCompany: Company? = nil
    
    private var companyManager: CompanyManager = CompanyManagerImpl.shared
    private var orderDetailsManager: OrderDetailsManager = OrderDetailsManagerImpl.shared
    private var cancellable: AnyCancellable?  // Store the subscription
    @Published var showAdvanceFilter = false
    @Published var orderDeliveryDate = Date()
    
    @Published var searchText: String = "" {
        didSet {
            filterOrderList()
        }
    }
    
    @Published var selectedDeliveryType: DeliveryType = .noneType {
        didSet {
            filterByDeliveryType(type: selectedDeliveryType)
        }
    }
    
    @Published var selectedOrderStatus: OrderStatusType? = .noneType {
        didSet {
            filterByStatusType(type: selectedOrderStatus)
        }
    }
    
    var allOrders: [OrderItemCellViewModel] = []
    
    init() {
        loadOrderDetailsList()
    }
    
    func reset() {
        searchText = ""
        showAdvanceFilter = false
        selectedOrderStatus = .noneType
        selectedDeliveryType = .noneType
        orderDeliveryDate = Date()
        loadOrderDetailsList(for: orderDeliveryDate)
    }
    
    func loadOrderDetailsList() {
        cancellable = companyManager.primaryCompanyUpdate
            .combineLatest(orderDetailsManager.orderDetailsListUpdates)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished receiving values.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { primaryCompany, orderList in
                DispatchQueue.main.async { [weak self] in
                    if let primaryCompany = primaryCompany, let orderList = orderList {
                        self?.primaryCompany = primaryCompany
                        self?.allOrders = orderList.map( { OrderItemCellViewModel(order: $0)})
                        self?.filterOrderDetailsList = orderList.map( { OrderItemCellViewModel(order: $0)})
                    }
                }
            })
    }
    
    func loadOrderDetailsList(for date: Date) {
        orderDetailsManager.observeOrderDetailsList(for: date.onlyDate)
    }
    
    func filterOrderList() {
        if searchText.isEmpty {
            filterOrderDetailsList = allOrders
        } else {
            filterOrderDetailsList = allOrders.filter { ($0.customerName).localizedCaseInsensitiveContains(searchText) || ($0.customerLocation).localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func filterByDeliveryType(type: DeliveryType?) {
        switch type {
        case .shop:
            filterOrderDetailsList = allOrders.filter { !$0.isTransport }
        case .transport:
            filterOrderDetailsList = allOrders.filter { $0.isTransport }
        case .noneType:
            filterOrderDetailsList = allOrders
        default:
            filterOrderDetailsList = allOrders
        }
    }
    
    func filterByStatusType(type: OrderStatusType?) {
        switch type {
        case .orderPlaced:
            filterOrderDetailsList = allOrders.filter { $0.status == OrderStatusType.orderPlaced.rawValue }
        case .preparing:
            filterOrderDetailsList = allOrders.filter { $0.status == OrderStatusType.preparing.rawValue }
        case .ready:
            filterOrderDetailsList = allOrders.filter { $0.status == OrderStatusType.ready.rawValue }
        case .deliver:
            filterOrderDetailsList = allOrders.filter { $0.status == OrderStatusType.deliver.rawValue }
        case .done:
            filterOrderDetailsList = allOrders.filter { $0.status == OrderStatusType.done.rawValue }
        case .cancel:
            filterOrderDetailsList = allOrders.filter { $0.status == OrderStatusType.cancel.rawValue }
        default:
            filterOrderDetailsList = allOrders
        }
    }
    
    
    func toggleExpansion(for order: OrderDetails) {
        if expandedRows.contains(order.id) {
            expandedRows.remove(order.id)
        } else {
            expandedRows.insert(order.id)
        }
    }
    
    func toggleAllExpansion() {
        filterOrderDetailsList.forEach { $0.isExpanded = isAllExpanded }
    }
    
    func isExpanded(order: OrderDetails) -> Bool {
        return expandedRows.contains(order.id)
    }
    
    deinit {
        cancellable?.cancel()
    }
}

class OrderItemCellViewModel: ObservableObject, Identifiable {
    var id: String
    @Published var customerName: String
    @Published var customerIconName: String
    @Published var customerLocation: String
    @Published var products: [OrderItem]
    @Published var deliveryAddress: String
    @Published var isTransport: Bool
    @Published var status: String
    @Published var isExpanded: Bool
    var orderDetails: OrderDetails
    
    init(order: OrderDetails) {
        id = order.id
        orderDetails = order
        customerName = order.customerName ?? ""
        customerIconName = (order.customerName ?? "").getTwoWords()
        customerLocation = order.customerAddress ?? ""
        products = order.items ?? []
        deliveryAddress = OrderItemCellViewModel.getDeliveryAddress(order: order)
        isTransport = order.transportAddressId == nil ? false : true
        status = order.orderStatus ?? ""
        isExpanded = false
    }
    
    static func getDeliveryAddress(order: OrderDetails) -> String {
        if let transportAddress = order.transportAddress {
            return transportAddress
        } else {
            return order.customerAddress ?? ""
        }
    }
}

extension String {
    func getTwoWords() -> String {
        var ouput: String = ""
        let array = self.split(separator: " ")
        for char in array {
            ouput += "\(String(char.first!).capitalized)"
            if ouput.count == 2 { break }
        }
        return ouput
    }
}

//
//func toggleExpansion(for order: OrderDetails) {
//    if expandedRows.contains(order.id) {
//        expandedRows.remove(order.id)
//    } else {
//        expandedRows.insert(order.id)
//    }
//}
//
//func toggleAllExpansion() {
//    if isAllExpanded {
//        orderList.forEach { order in
//            expandedRows.insert(order.id)
//        }
//    } else {
//        expandedRows.removeAll()
//    }
//}
//
//func isExpanded(order: OrderDetails) -> Bool {
//    return expandedRows.contains(order.id)
//}
