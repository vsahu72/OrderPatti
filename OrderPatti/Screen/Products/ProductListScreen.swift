//
//  ProductListScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 22/09/24.
//

import SwiftUI
import Combine

final class ProductListViewModel: ObservableObject {
    var companyList: [Company] = []
    @Published var productList: [Product] = []
    var primaryCompany: Company?
    private let productManager: ProductManager = ProductManagerImpl.shared
    private let companyManager: CompanyManager = CompanyManagerImpl.shared
    private var cancellable: AnyCancellable?  // Store the subscription
    
    init() {
        loadProductList()
    }
    
    func loadProductList() {
        cancellable = companyManager.companyListUpdates
            .combineLatest(productManager.productListUpdates)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished receiving values.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { companies, products in
                DispatchQueue.main.async { [weak self] in
                    self?.companyList = companies ?? []
                    self?.primaryCompany = companies?.first
                    self?.productList = products ?? []
                }
            })
    }
    
    deinit {
        print("@@@@... deinit")
        cancellable?.cancel()
    }
    
}

struct ProductListScreen: View {
    
    @ObservedObject var viewModel: ProductListViewModel
    
    init(viewModel: ProductListViewModel = ProductListViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            List {
                 ForEach(viewModel.productList) { product in
                     NavigationLink(destination: EditProductScreen(viewModel: EditProductViewModel(product: product, companyList: viewModel.companyList, mode: .edit))) {
                        ExtractedView(product: product)
                    }
                }
            }
            .id(UUID())
            .listRowSpacing(16)
        }
        .navigationTitle("Product List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(destination: EditProductScreen(viewModel: EditProductViewModel(companyList: viewModel.companyList, mode: .create))) {
                   Text("Add")
                }
            }
        }
    }
}

#Preview {
    ProductListScreen()
}

struct ExtractedView: View {
    
    var product: Product
    
    var body: some View {
        VStack {
            HStack {
                Text("Product Name:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(product.name ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            HStack {
                Text("Price:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text("\(product.mrp ?? 0)")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            
        }
        .padding(10)
    }
}
