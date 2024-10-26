//
//  ProductSuggestionScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 23/09/24.
//


import SwiftUI
import Combine


struct ProductSuggestionItemUI: Identifiable {
    var id: String
    var quantity: Int?
    var priority: Int?
    var product: Product?
    
    init(productSuggestion: ProductSuggestion, product: Product?) {
        self.id = productSuggestion.id
        self.quantity = productSuggestion.quantity
        self.priority = productSuggestion.priority
        self.product = product
    }
}

final class ProductSuggestionViewModel: ObservableObject {
    
    //Properties
    var productList: [Product] = []
    var companyList: [Company] = []
    var primaryCompany: Company?
    
    //Publisher
    @Published var productSuggestionList: [ProductSuggestionItemUI] = []
    
    // Manager
    private let productSuggestionManager: ProductSuggestionManager = ProductSuggestionManagerImpl.shared
    private let companyManager: CompanyManager = CompanyManagerImpl.shared
    private let productManager: ProductManager = ProductManagerImpl.shared
    
    // Store the subscription
    private var cancellable: AnyCancellable?
    
    init() {
        loadProductList()
    }
    
    func getproductSuggestionList(productSuggestionList: [ProductSuggestion]?, products: [Product]?) -> [ProductSuggestionItemUI] {
        var productSuggestionListItemUI: [ProductSuggestionItemUI] = []
        productSuggestionList?.forEach { productSuggestion in
            if let product = products?.first(where: { $0.id == productSuggestion.productId}) {
                let productSuggestionItemUI = ProductSuggestionItemUI(productSuggestion: productSuggestion, product: product)
                productSuggestionListItemUI.append(productSuggestionItemUI)
            }
        }
        return productSuggestionListItemUI.sorted(by: { $0.priority ?? 0 > $1.priority ?? 0 })
    }
    func loadProductList() {
        cancellable = companyManager.companyListUpdates
            .combineLatest(productManager.productListUpdates, productSuggestionManager.productSuggestionListUpdates)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished receiving values.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { companies, products, productsSuggestionList in
                DispatchQueue.main.async { [weak self] in
                    self?.companyList = companies ?? []
                    self?.primaryCompany = companies?.first
                    self?.productList = products ?? []
                    guard let productSuggestionList = self?.getproductSuggestionList(productSuggestionList: productsSuggestionList, products: products) else { return }
                    self?.productSuggestionList = productSuggestionList
                }
            })
    }
    
    deinit {
        print("@@@@... deinit")
        cancellable?.cancel()
    }
    
}

struct ProductSuggestionScreen: View {
    
    @ObservedObject var viewModel: ProductSuggestionViewModel
    
    init(viewModel: ProductSuggestionViewModel = ProductSuggestionViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            List {
                 ForEach(viewModel.productSuggestionList) { productItem in
                     NavigationLink(destination: EditProductSuggestionScreen(viewModel: EditProductSuggestionViewModel(productSuggestionItem: productItem, products: viewModel.productList, companyList: viewModel.companyList, primaryCompany: viewModel.primaryCompany, mode: .edit))) {
                         ProductSuggestionCellView(item: productItem)
                    }
                }
            }
            .listRowSpacing(16)
        }
        .navigationTitle("Product Suggestion List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(destination: EditProductSuggestionScreen(viewModel: EditProductSuggestionViewModel(products: viewModel.productList, companyList: viewModel.companyList, primaryCompany: viewModel.primaryCompany, mode: .create))) {
                   Text("Add")
                }
            }
        }
    }
}

#Preview {
    ProductListScreen()
}

struct ProductSuggestionCellView: View {
    
    var item: ProductSuggestionItemUI
    
    var body: some View {
        VStack {
            HStack {
                Text("Product Name:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(item.product?.name ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            HStack {
                Text("Quantity:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text("\(item.quantity ?? 0)")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            
        }
        .padding(10)
    }
}
