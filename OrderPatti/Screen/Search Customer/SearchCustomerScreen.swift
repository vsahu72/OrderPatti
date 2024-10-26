//
//  SearchCustomerScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 01/09/24.
//

import SwiftUI
import Combine

struct SearchCustomerScreen: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SearchCustomerViewModel
    var onDismiss: ((_ customer: Customer) -> Void)?
    
    init(viewModel: SearchCustomerViewModel, onDismiss:  ((_ customer: Customer) -> Void)?) {
        self.viewModel = viewModel
        self.onDismiss = onDismiss
     
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView (showsIndicators: false){
                    ForEach(viewModel.filterCustmerList) { customer in
                        VStack {
                            VStack {
                                VStack {
                                    HStack{
                                        CircularLabel(text: getShortName(customer: customer))
                                        VStack (alignment: .leading, spacing: 2){
                                            CardTitleLabel(title: getName(customer: customer))
                                            IconLabel(text: getLocation(customer: customer))
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }.onTapGesture {
                            onDismiss?(customer)
                            dismiss()
                        }
                        .padding(10)
                        .background(.white)
                        .clipped()
                        .shadow(radius: 2)
                    }
                    
                }.scrollClipDisabled(true)
            }
            .padding(.horizontal)
            .navigationTitle("Select Customer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                       ToolbarItemGroup(placement: .topBarLeading) {
                           Button("Close") {
                               dismiss()
                           }
                       }
                   }
        }
        .searchable(text: $viewModel.searchText)
    }
    
    func getName(customer: Customer) -> String {
        return customer.name ?? ""
    }
    
    func getShortName(customer: Customer) -> String {
        return (customer.name ?? "").getTwoWords()
    }
    
    func getLocation(customer: Customer) -> String {
        return customer.address?.city ?? ""
    }
}

#Preview {
    return SearchCustomerScreen(viewModel: SearchCustomerViewModel(), onDismiss: nil)
}

class SearchCustomerViewModel: ObservableObject {
    
    private var companyManager: CompanyManager = CompanyManagerImpl.shared
    private var customerManager: CustomerManager = CustomerManagerImpl.shared
    private var cancellable: AnyCancellable?  // Store the subscription
    
    var primaryCompany: Company? = nil
    var customers: [Customer] = []
    
    @Published var filterCustmerList: [Customer] = []
    
    @Published var searchText: String = "" {
        didSet {
            filterCustomerList()
        }
    }
    
    init() {
        loadCustomerList()
    }
    
    func filterCustomerList() {
        if searchText.isEmpty {
            filterCustmerList = customers
        } else {
            filterCustmerList = customers.filter { ($0.name ?? "").localizedCaseInsensitiveContains(searchText) || ($0.address?.city ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func loadCustomerList() {
        cancellable = companyManager.primaryCompanyUpdate
            .combineLatest(customerManager.customerListUpdates)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished receiving values.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { primaryCompany, customers in
                DispatchQueue.main.async { [weak self] in
                    if let primaryCompany = primaryCompany, let customers = customers {
                        self?.primaryCompany = primaryCompany
                        self?.customers = customers
                        self?.filterCustmerList = customers
                    }
                }
            })
    }
}
