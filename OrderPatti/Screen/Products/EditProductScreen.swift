//
//  EditProductScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 08/09/24.
//

import SwiftUI
import Combine


class EditProductViewModel: ObservableObject {
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private let productManager: ProductManager = ProductManagerImpl.shared
    var mode: ScreenDisplayMode
    var product: Product?
    
    @Published var companyList: [Company] = []
    @Published var selectedCompany: Company? = nil
    
    @Published var productName: String = ""
    @Published var productShortName: String = ""
    
    @Published var unit: String = ""
    @Published var price: String = ""
    
    var isValid: Bool {
        !productName.isEmpty &&
        !(selectedCompany == nil) &&
        !productShortName.isEmpty &&
        !price.isEmpty &&
        !unit.isEmpty
    }
    
    init(product: Product? = nil, companyList: [Company], mode: ScreenDisplayMode) {
        self.mode = mode
        self.companyList = companyList
        selectedCompany = companyList.first
        if mode == .edit, let product = product {
            self.product = product
            self.setupValue(product: product)
        }
    }
    
    func setupValue(product: Product) {
        productName = product.name ?? ""
        productShortName = product.shortName ?? ""
        price = "\(product.mrp ?? 0.0)"
        unit = product.unit ?? ""
    }
    
    func executeAction() {
        if mode == .edit {
            update()
        } else {
            save()
        }
    }
    
    private func save(){
        if !isValid { return }
        let product = Product(id: "", companyID: getSlectedCompanyId(), name: productName, shortName: productShortName, unit: unit, mrp: price.toDecimal())
        Task { [product] in
            do {
                try await productManager.createProduct(product: product)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
      
    }
    
    private func update(){
        if !isValid { return }
        let product = Product(id: (product?.id)!, companyID: getSlectedCompanyId(), name: productName, shortName: productShortName, unit: unit, mrp: price.toDecimal())
        Task { [product] in
            do {
                try await productManager.updateProduct(product: product)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
    }
    
    func deleat() {
        guard let productId = product?.id else { return }
        
        Task { [productId] in
            do {
                try await productManager.deleteProduct(productId: productId)
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
    
    func clearAll() {
        productName = ""
        productShortName = ""
        price = ""
        unit = ""
        selectedCompany = companyList.first
    }
    
    func getSlectedCompanyId() -> String {
        guard let company = companyList.first(where: { $0  == selectedCompany } ) else { return "" }
        return company.id
    }
}



struct EditProductScreen: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: EditProductViewModel
    
    init(viewModel: EditProductViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Form {
                company
                general
                clearAll
                delete
            }
            .onReceive(viewModel.viewDismissalModePublisher) { shouldPop in
                if shouldPop {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.mode == .edit ? "update" : "Save") {
                        viewModel.executeAction()
                    }.disabled(!viewModel.isValid)
                }
            }
        }
    }
}

extension EditProductScreen {
    var general: some View {
        Section {
            TextField("Product Name", text: $viewModel.productName)
                .textContentType(.organizationName)
                .keyboardType(.namePhonePad)
            
            TextField("Short Name", text: $viewModel.productShortName)
                .textContentType(.organizationName)
                .keyboardType(.namePhonePad)
            
            TextField("Unit", text: $viewModel.unit)
                .textContentType(.organizationName)
                .keyboardType(.namePhonePad)
            
            TextField("Price", text: $viewModel.price)
                .keyboardType(.numberPad)
        } header: {
            Text("Product Info")
        }.headerProminence(.increased)
    }
}

extension EditProductScreen {
    var company: some View {
        Section {
            Picker("Select Company", selection: $viewModel.selectedCompany) {
                Text("None").tag( nil as Company?)
                ForEach(viewModel.companyList, id: \.self) { item in
                    Text(item.name ?? "").tag( item as Company?)
                }
            }.pickerStyle(.menu)
        } header: {
            Text("Company")
        }.headerProminence(.increased)
    }
}




extension EditProductScreen {
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

extension EditProductScreen {
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
    EditProductScreen(viewModel: EditProductViewModel(companyList: [], mode: .create))
}
