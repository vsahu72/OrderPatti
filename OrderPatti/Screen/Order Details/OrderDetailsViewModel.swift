//
//  OrderDetailsViewModel.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 01/10/24.
//

import Foundation
import SwiftUI
import Combine

enum DeliveryType: String, CaseIterable {
    case noneType = "None"
    case shop = "Shop"
    case transport = "Transport"
}

struct ProductSuggestionUI: Hashable {
    var id: String
    var product: Product?
    var quantity: Int?
    var priority: Int?
    
    init(productSuggestion: ProductSuggestion, product: Product?) {
        self.id = productSuggestion.id
        self.product = product
        self.quantity = productSuggestion.quantity
        self.priority = productSuggestion.priority
    }
}

class OrderDetailsViewModel: ObservableObject, Identifiable {
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
   
    //Order information
    var orderId: String?
    var orderDetails: OrderDetails?
    
    // Customer information
    var customerId: String = ""
    @Published var customerName: String = ""
    @Published var customerLocation: String = ""
    
    //Time
    var createdDate: Date? = nil
    var modifiedDate: Date? = nil
    
    //Date
    @Published var selectedDate: Date = Date()
    
    //Display Mode
    @Published var mode: ScreenDisplayMode = .display
    
    //Status
    @Published var selectedOrderStatus: String? = OrderStatusType.orderPlaced.rawValue
    
    //Delivery
    @Published var selectedDeliveryOption: DeliveryOptions = .shop
    @Published var transportList: [Address] = []
    @Published var selectedTransportAddress: Address? = nil
    
    //Bilty Number
    @Published var biltyNumber: String? = nil
    
    //Product list
    @Published var productList: [Product]? = nil 
    
    // Order Items
    @Published var orderItems: [OrderItem] = []
    
    //Delivery Address
    @Published var deliveryAddress: String = ""
    @Published var isTransport: Bool = false
    @Published var status: String = ""
    
    //Suggestion List
    var productSuggestionList: [ProductSuggestionUI] = []

    // Supporting data
    var primaryCompany: Company?
   //  var productList: [Product] = []
   
    // Manager
    private var companyManager: CompanyManager = CompanyManagerImpl.shared
    private var productManager: ProductManager = ProductManagerImpl.shared
    private var productSuggestionManager: ProductSuggestionManager = ProductSuggestionManagerImpl.shared
    private var transportAddressManager: TransportAddressManager = TransportAddressManagerImpl.shared
    private var orderDetailsManager: OrderDetailsManager = OrderDetailsManagerImpl.shared
    
    private var cancellable: AnyCancellable?  // Store the subscription
    
    var isValid: Bool {
        !customerName.isEmpty &&
        !customerLocation.isEmpty &&
        !orderItems.isEmpty
    }
    
    init(orderDetails: OrderDetails?, displayMode: ScreenDisplayMode) {
       
        self.orderDetails = orderDetails
        self.orderItems = orderDetails?.items ?? []
        self.updateMode(mode: displayMode)
        self.setupValues()
        loadOrderDetails()
        
    }
    
    func loadOrderDetails() {
        
        cancellable = companyManager.primaryCompanyUpdate
            .combineLatest(productManager.productListUpdates)
            .combineLatest(productSuggestionManager.productSuggestionListUpdates)
            .combineLatest(transportAddressManager.transportListUpdates)
            .map { (arg1, third) in
                let ((zero, first), second) = arg1
                return (zero, first, second, third)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished receiving values.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { primaryCompany, products, suggestion, trasports in
                DispatchQueue.main.async { [weak self] in
                    self?.primaryCompany = primaryCompany
                    self?.productList = products ?? []
                    if let tempProducts = products, let tempSuggestions = suggestion {
                        self?.setupProductSuggestionList(products: tempProducts, suggestions: tempSuggestions)
                    }
                    self?.transportList = trasports ?? []
                    self?.setupValues()
                    //self?.orderItems = orderDetails.items ?? []
                    
                }
            })
    }
    
    func setupProductSuggestionList(products: [Product], suggestions: [ProductSuggestion]) {
        if products.isEmpty && suggestions.isEmpty { return }
        productSuggestionList = suggestions.map { item in
            let product = products.first(where: { $0.id == item.productId })
            return ProductSuggestionUI(productSuggestion: item, product: product)
        }
    }
    
    func setupValues() {
        guard let order = orderDetails else { return }
        customerName = order.customerName ?? ""
        customerLocation = order.customerAddress ?? ""
        orderItems = order.items ?? []
        deliveryAddress = getDeliveryAddress(order: order)
        isTransport = order.transportAddressId == nil ? true : false
        status = order.orderStatus ?? ""
        selectedOrderStatus = order.orderStatus ?? ""
        selectedDate = order.deliveryDate ?? Date()
        createdDate = order.createdDate
        modifiedDate = order.modifiedDate
        
        if let transPortAddressId = order.transportAddressId, let transportAddress = transportList.first(where:  { $0.id == transPortAddressId }){
            selectedDeliveryOption = .transport
            selectedTransportAddress = transportAddress
        } else {
            selectedDeliveryOption = .shop
            selectedTransportAddress = nil
        }
    }
    
    func getDeliveryAddress(order: OrderDetails) -> String {
        if let transportAddress = order.transportAddress {
            return transportAddress
        } else {
            return order.customerAddress ?? ""
        }
    }
    
    func getAddProductView(orderItem: OrderItem? = nil) -> some View {
        let viewModel = AddOrderProductViewModel(products: productList ?? [], orderItem: orderItem, mode: orderItem == nil ? .create : .edit)
        viewModel.delegate = self
        return AddOrderProductView(viewModel: viewModel)
    }
    
    func getExecuteActionTitle() -> String {
        switch mode {
        case .edit:
            return "Update"
        case .create:
            return "Save"
        case .display:
            return "Print"
        }
    }
    
    func removedOrderItem(item: OrderItem) {
        
        if let index = self.orderItems.firstIndex(where: { $0.id == item.id }) {
            orderItems.remove(at: index)
        }
    }
    
    func suggestionCellAction(suggestion: ProductSuggestionUI) {
        
        if let index = self.orderItems.firstIndex(where: { $0.productId == suggestion.product?.id }) {
            let item = self.orderItems[index]
            let updatedOrderItem = OrderItem(id: item.id, productId: suggestion.product?.id, productName: suggestion.product?.name, unit: suggestion.product?.unit, quantity: (item.quantity ?? 0) + (suggestion.quantity ?? 0), rate: suggestion.product?.mrp, discountedRate: suggestion.product?.mrp)
            self.orderItems[index] = updatedOrderItem
        } else {
            let newOrderItem = OrderItem(id: Utils.generateUniqueId(),productId: suggestion.product?.id, productName: suggestion.product?.name, unit: suggestion.product?.unit, quantity: suggestion.quantity, rate: suggestion.product?.mrp, discountedRate: suggestion.product?.mrp)
            self.orderItems.append(newOrderItem)
        }
        
    }
    
    func modifyOrderItems(item: OrderItem) {
        if let index = self.orderItems.firstIndex(where: { $0.id == item.id }) {
            self.orderItems[index] = item
        } else {
            self.orderItems.append(item)
        }
    }
    
    private func getTotalPrice() -> Decimal {
        return orderItems.reduce(Decimal(0)) { partialResult, item in
            let quantity = Decimal(item.quantity ?? 0)
            let rate = item.rate ?? 0.0
            return partialResult + quantity * rate
        }

    }
    
    private func getTotalDiscountedPrice() -> Decimal {
        return orderItems.reduce(Decimal(0)) { partialResult, item in
            let quantity = Decimal(item.quantity ?? 0)
            let discountedRate = item.discountedRate ?? 0.0
            return partialResult + quantity * discountedRate
        }
    }
    
    func executeAction() {
        if mode == .create {
            save()
        } else if mode == .edit {
            update()
        } else {
            print("Print button pressed")
        }
    }
    
    func save() {
        let orderDetailObject = OrderDetails(id: "1",
                                             createdDate: Date(),
                                             modifiedDate: modifiedDate,
                                             deliveryDate: selectedDate.onlyDate,
                                             companyId: primaryCompany?.id,
                                             companyName: primaryCompany?.name,
                                             customerId: customerId,
                                             customerName: customerName,
                                             customerAddress: customerLocation,
                                             items: orderItems, 
                                             totalPrice: getTotalPrice(),
                                             totalDiscountedPrice: getTotalDiscountedPrice(),
                                             transportAddressId: selectedTransportAddress?.id,
                                             transportAddress: selectedTransportAddress?.address1,
                                             orderStatus: selectedOrderStatus,
                                             biltyNumber: biltyNumber)
        Task { [orderDetailObject] in
            do {
                try await  orderDetailsManager.createOrderDetails(orderDetails: orderDetailObject)
                self.goBack()
                
            } catch {
               print("Error to update order detail object =\(error)")
            }
        }
        
    }
    
    func update() {
        guard let orderItem = orderDetails else { return }
        let orderDetailObject = OrderDetails(id: orderItem.id,
                                             createdDate: createdDate,
                                             modifiedDate: Date(),
                                             deliveryDate: selectedDate.onlyDate,
                                             companyId: primaryCompany?.id,
                                             companyName: primaryCompany?.name,
                                             customerId: customerId,
                                             customerName: customerName,
                                             customerAddress: customerLocation,
                                             items: orderItems,
                                             totalPrice: getTotalPrice(),
                                             totalDiscountedPrice: getTotalDiscountedPrice(),
                                             transportAddressId: selectedTransportAddress?.id,
                                             transportAddress: selectedTransportAddress?.address1,
                                             orderStatus: selectedOrderStatus,
                                             biltyNumber: biltyNumber)
        Task { [orderDetailObject] in
            do {
                try await  orderDetailsManager.updateOrderDetails(orderDetails: orderDetailObject)
                self.goBack()
            } catch {
               print("Error to update order detail object =\(error)")
            }
        }
       
    }
    
    func deleat() {
        guard let orderId = orderDetails?.id else { return }
        
        Task { [orderId] in
            do {
                try await orderDetailsManager.deleteOrderDetails(orderDetailsId: orderId)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async { [weak self] in
            self?.viewDismissalModePublisher.send(true)
        }
       
    }
}

extension OrderDetailsViewModel {
    func updateCustomerInformation(customer: Customer) {
        customerId = customer.id
        customerName = customer.name ?? ""
        customerLocation = customer.address?.city ?? ""
    }
    
    func updateMode(mode: ScreenDisplayMode) {
        self.mode = mode
    }
}

extension OrderDetailsViewModel: ProductActionDelegate {
    func didItemAdded(orderItem: OrderItem) {
        modifyOrderItems(item: orderItem)
    }
    
    func didItemUpdated(orderItem: OrderItem) {
        modifyOrderItems(item: orderItem)
    }
}
