//
//  CustomerListScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 28/09/24.
//

import Foundation
import SwiftUI
import Combine

struct CustomerListScreen: View {
    @ObservedObject var viewModel: CustomerListViewModel
    
    init() {
        self.viewModel = CustomerListViewModel()
    }
    
    var body: some View {
        VStack {
            ScrollView (showsIndicators: false){
                ForEach(viewModel.filterCustmerList) { customer in
                    NavigationLink(destination: EditCustomerScreen(viewModel: EditCustomerViewModel(customer: customer, mode: .edit))) {
                        CustomerCellView(customer: customer)
                    }
                }.id(UUID())
            }.scrollClipDisabled(true)
        }
        .padding(.horizontal)
        .navigationTitle("Select Customer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(destination: EditCustomerScreen(viewModel: EditCustomerViewModel(mode: .create))) {
                   Text("Add")
                }
            }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

#Preview {
    CustomerListScreen()
}

class CustomerListViewModel: ObservableObject {
    
    var primaryCompany: Company? = nil
    private var companyManager: CompanyManager = CompanyManagerImpl.shared
    private var customerManager: CustomerManager = CustomerManagerImpl.shared
    private var cancellable: AnyCancellable?  // Store the subscription
    
    @Published var filterCustmerList: [Customer] = []
    
    @Published var searchText: String = "" {
        didSet {
            filterCustomerList()
        }
    }
    var customers: [Customer] = []
    
    init() {
        loadCustomerList()
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
    
    func filterCustomerList() {
        if searchText.isEmpty {
            filterCustmerList = customers
        } else {
            filterCustmerList = customers.filter { ($0.name ?? "").localizedCaseInsensitiveContains(searchText) || ($0.address?.city ?? "").localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct CustomerCellView: View {
    var customer: Customer
    var body: some View {
        HStack {
            CircularLabel(text: getShortName(customer: customer))
            VStack (alignment: .leading, spacing: 2){
                CardTitleLabel(title: getName(customer: customer))
                IconLabel(text: getLocation(customer: customer))
            }
            Spacer()
        }
        .padding(10)
        .background(.white)
        .clipped()
        .shadow(radius: 2)
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
