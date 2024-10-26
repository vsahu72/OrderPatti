//
//  EditProductSuggestionScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 08/09/24.
//

import SwiftUI
import Combine

struct EditProductSuggestionScreen: View {
    @ObservedObject var viewModel: EditProductSuggestionViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    init(viewModel: EditProductSuggestionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack {
            Form {
                company
                product
                quantity
                priority
                clearAll
                if viewModel.mode == .edit {
                    delete
                }
            }.onReceive(viewModel.viewDismissalModePublisher) { shouldPop in
                if shouldPop {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add product suggestion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.mode == .create ? "Save" : "Update") {
                        viewModel.executeAction()
                    }.disabled(!viewModel.isValid)
                }
            }
        }
    }
}

extension EditProductSuggestionScreen {
    var company: some View {
        Section {
            Picker("Select Company", selection: $viewModel.selectedCompany) {
                Text("None").tag(nil as Company?)
                ForEach(viewModel.companyList, id: \.name) { item in
                    Text(item.name ?? "").tag(item as Company?)
                }
            }.pickerStyle(.menu)
            
        } header: {
            Text("Company")
        }.headerProminence(.increased)
    }
}

extension EditProductSuggestionScreen {
    var product: some View {
        Section {
            Picker("Select product", selection: $viewModel.selectedProduct) {
                Text("None").tag(nil as Product?)
                ForEach(viewModel.productList, id: \.self) { item in
                    Text(item.name ?? "").tag(item as Product?)
                }
            }.pickerStyle(.navigationLink)
            
        } header: {
            Text("Product")
        }.headerProminence(.increased)
    }
}

extension EditProductSuggestionScreen {
    var quantity: some View {
            Section {
                VStack {
                    TextField("Quantity", text: $viewModel.quantity)
                        .keyboardType(.numberPad)
                }
            } header: {
                Text("Quantity")
            }.headerProminence(.increased)
        }
}

extension EditProductSuggestionScreen {
    var priority: some View {
            Section {
                VStack {
                    TextField("Priority", text: $viewModel.priority)
                        .keyboardType(.numberPad)
                }
            } header: {
                Text("Priority")
            }.headerProminence(.increased)
        }
}




extension EditProductSuggestionScreen {
    var clearAll: some View {
        Section {
         
            Button("Clear all", role: .destructive) {
                withAnimation {
                    viewModel.clearAll()
                }
            }
        }
    }
}

extension EditProductSuggestionScreen {
    var delete: some View {
        Section {
         
            Button("Delete", role: .destructive) {
                withAnimation {
                    viewModel.deleat()
                }
            }
        }
    }
}

#Preview {
    EditProductSuggestionScreen(viewModel: EditProductSuggestionViewModel(productSuggestionItem: nil, products: [], companyList: [], primaryCompany: nil, mode: .create))
}

class EditProductSuggestionViewModel: ObservableObject {
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    // Manager
    private let productSuggestionManager: ProductSuggestionManager = ProductSuggestionManagerImpl.shared
    
    //Properties
    var productList: [Product] = []
    var companyList: [Company] = []
    var primaryCompany: Company?
    var product: Product?
    var mode: ScreenDisplayMode = .display
    
    @Published var selectedCompany: Company? = nil
    @Published var selectedProduct: Product? = nil
    @Published var productName: String = ""
    @Published var quantity: String = ""
    @Published var priority: String = ""
    var productSuggestionItemUI: ProductSuggestionItemUI?
    
    var isValid: Bool {
        !(selectedCompany == nil) &&
        !(selectedProduct == nil) &&
        !quantity.isEmpty &&
        !priority.isEmpty
    }
    
    init(productSuggestionItem: ProductSuggestionItemUI? = nil,
         products: [Product],
         companyList: [Company],
         primaryCompany: Company?,
         mode: ScreenDisplayMode) {
        self.mode = mode
        if mode == .edit, let productSuggestionItem = productSuggestionItem {
            productSuggestionItemUI = productSuggestionItem
            setupValue(productSuggestionItem: productSuggestionItem)
        }
        self.productList = products
        self.companyList = companyList
        self.primaryCompany = primaryCompany
        self.selectedCompany = primaryCompany
    }
    
    func setupValue(productSuggestionItem: ProductSuggestionItemUI) {
        guard  let product =  productSuggestionItem.product else { return }
        productName = product.name ?? ""
        quantity = "\(productSuggestionItem.quantity ?? 0)"
        priority = "\(productSuggestionItem.priority ?? 0)"
        selectedCompany = primaryCompany
        selectedProduct = product
    }
    
    
    func clearAll() {
        productName = ""
        selectedProduct = nil
        priority = ""
        quantity = ""
        selectedCompany = primaryCompany
    }
    
    func executeAction() {
        if mode == .edit {
            update()
        } else {
            save()
        }
    }
    
    func save() {
        if !isValid { return }
        let quantity = Int(quantity) ?? 0
        let priority = Int(priority) ?? 1000
        let selectedProductId = selectedProduct?.id ?? ""
        let item = ProductSuggestion(id: "",
                                     productId: selectedProductId,
                                     quantity: quantity,
                                     priority: priority)
        Task { [item] in
            do {
                try await productSuggestionManager.createproductSuggestion(productSuggestion: item)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
    }
    
    func update() {
        if !isValid { return }
        guard let id = productSuggestionItemUI?.id else { return }
        let quantity = Int(quantity) ?? 0
        let priority = Int(priority) ?? 1000
        let selectedProductId = selectedProduct?.id ?? ""
        let item = ProductSuggestion(id: id,
                                     productId: selectedProductId,
                                     quantity: quantity,
                                     priority: priority)
        Task { [item] in
            do {
                try await   productSuggestionManager.updateproductSuggestion(productSuggestion: item)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
    }
    
    func deleat() {
        guard let productSuggestionId = productSuggestionItemUI?.id else { return }
        
        Task { [productSuggestionId] in
            do {
                try await productSuggestionManager.deleteProductSuggestion(productSuggestionId: productSuggestionId)
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

