//
//  FeatureListScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 08/09/24.
//

import SwiftUI

struct FeatureListScreen: View {
    
    @State var selectedFeature: NavigationType?
    
    enum NavigationType: Hashable {
        case company
        case product
        case customer
        case productSuggestion
        case transportAddress
        
        var title: String {
            switch self {
            case .company: "Company"
            case .product: "Product"
            case .customer: "Customer"
            case .productSuggestion: "Product Suggestion"
            case .transportAddress: "Transport Address"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(NavigationType.company.title, value: NavigationType.company)
                NavigationLink(NavigationType.customer.title, value: NavigationType.customer)
                NavigationLink(NavigationType.product.title, value: NavigationType.product)
                NavigationLink(NavigationType.productSuggestion.title, value: NavigationType.productSuggestion)
                NavigationLink(NavigationType.transportAddress.title, value: NavigationType.transportAddress)
            }
            .navigationDestination(for: NavigationType.self) { navigationType in
                switch navigationType {
                case NavigationType.company: CompanyListScreen()
                case NavigationType.customer: CustomerListScreen()
                case NavigationType.product: ProductListScreen()
                case NavigationType.productSuggestion: ProductSuggestionScreen()
                case NavigationType.transportAddress: TransportAddressListScreen()
                }
            }
            .navigationTitle("Features")
        }
        
    }
}

#Preview {
    FeatureListScreen()
}
