//
//  AddOrderProductView.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 02/09/24.
//

import SwiftUI

protocol ProductActionDelegate: AnyObject {
    func didItemAdded(orderItem: OrderItem)
    func didItemUpdated(orderItem: OrderItem)
}

class AddOrderProductViewModel: ObservableObject {
    
    weak var delegate: ProductActionDelegate? = nil
    @Published var orderItem: OrderItem? = nil
    @Published var mode: ScreenDisplayMode = .display
    @Published var products: [Product] = []
    
    //Selected Order item
    @Published var selectedProductId: String? = nil
    @Published var selectedStatus: String? = OrderStatusType.orderPlaced.rawValue
    @Published var quantity: String = ""
    
    var selectedProduct: Product? {
        products.first { $0.name == selectedProductId }
    }
    
    var isValid: Bool {
        !quantity.isEmpty &&
        !(selectedStatus?.isEmpty ?? true) &&
        selectedProduct != nil
    }
    
    init(products: [Product], orderItem: OrderItem? = nil, mode: ScreenDisplayMode) {
        self.products = products
        self.mode = mode
        if mode == .edit {
            self.orderItem = orderItem
            setupProduct()
        }
    }
    
    func setupProduct() {
        guard let orderItem = self.orderItem else { return }
        selectedProductId = products.first(where: { $0.id == orderItem.productId })?.name
        quantity = "\(orderItem.quantity ?? 0)"
        selectedStatus = orderItem.orderItemStatus ?? OrderStatusType.orderPlaced.rawValue
    }
    
    func excuteAction() {
        if mode == .edit {
           update()
        } else {
            save()
        }
    }
    
    func save() {
        if !isValid { return }
        guard let product = selectedProduct else { return }
        let newItem = OrderItem(id: Utils.generateUniqueId(),
                             productId: product.id,
                             productName: product.name,
                             unit: product.unit,
                             quantity: Int(quantity) ?? 0,
                             rate: product.mrp,
                             discountedRate: 0,
                             orderItemStatus: selectedStatus)
        delegate?.didItemAdded(orderItem: newItem)
    }
    
    func update() {
        if !isValid { return }
        guard let product = selectedProduct else { return }
        guard let orderItem = orderItem else { return }
        let updatedTtem = OrderItem(id: orderItem.id,
                             productId: product.id,
                             productName: product.name,
                             unit: product.unit,
                             quantity: Int(quantity) ?? 0,
                             rate: product.mrp,
                             discountedRate: 0,
                             orderItemStatus: selectedStatus)
        delegate?.didItemUpdated(orderItem: updatedTtem)
    }
}


struct AddOrderProductView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddOrderProductViewModel
    
    init(viewModel: AddOrderProductViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack (alignment: .leading){
                    HStack {
                        Text("Product:")
                        Spacer()
                        DropDownPicker(
                            selection: $viewModel.selectedProductId,
                            options: viewModel.products.map({ $0.name ?? "" }),
                            maxWidth: .infinity
                        )

                    }
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 2)
                .padding()
                .zIndex(100)
                
                VStack (alignment: .leading){
                    Text("Quantity")
                    TextField("Enter quantity", text: $viewModel.quantity)
                        .foregroundColor(.darkText)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .background(Color.white)
                .clipped()
                .shadow(radius: 2)
                .padding()
                
                StatusView(status: $viewModel.selectedStatus, mode: $viewModel.mode)
                    .zIndex(100)
//                VStack (alignment: .leading){
//                    Text("Status")
//    
//                }
//                .padding()
//                .background(Color.white)
//                .clipped()
//                .shadow(radius: 2)
//                .padding(.horizontal)
                
                
                Button(action: {
                    viewModel.excuteAction()
                    dismiss()
                    
                }, label: {
                    HStack {
                        Spacer()
                        Text("Done")
                        Spacer()
                    }.padding(10)
                        .font(.title2)
                        .foregroundColor(viewModel.isValid ? Color.themeColor : Color.gray)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(viewModel.isValid ? Color.themeColor : Color.gray, lineWidth: 2)
                        )
                })
    
                .padding()
                Spacer()
            }
            .navigationTitle("Add Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

extension AddOrderProductView {
    struct StatusView: View {
        @Binding var status: String?
        @Binding var mode: ScreenDisplayMode
        var body: some View {
            if mode != .create {
                HStack {
                    Spacer()
                    Text("Select Status: ")
                    if mode == .edit {
                        DropDownPicker(
                            selection: $status,
                            options: OrderStatusType.allCases.map({ $0.rawValue })
                        )
                    }
                    Spacer()
                }
                .padding(10)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .background(OrderStatusType.getColor(status: status))
            }
        }
    }
}

#Preview {
    AddOrderProductView(viewModel: AddOrderProductViewModel(products: [], mode: .edit))
}
