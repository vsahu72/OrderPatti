//
//  CompanyListScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 08/09/24.
//

import SwiftUI
import Combine

final class CompanyListViewModel: ObservableObject {
    @Published var companyList: [Company] = []
    private var companyManager: CompanyManager = CompanyManagerImpl.shared
    private var cancellable: AnyCancellable?  // Store the subscription
    
    init() {
        loadCompanyList()
    }
    
    func loadCompanyList() {
        cancellable = companyManager.companyListUpdates.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("@@@@.. completion")
                case .failure(let error):
                    print("@@@@.. error: \(error)")
                }
            },
            receiveValue: { [weak self] values in
                print("@@@@.. values =\(String(describing: values))")
                DispatchQueue.main.async { [weak self] in
                    guard let list = values, !list.isEmpty else {
                        return
                    }
                    self?.companyList = list
                }
                
            }
        )
    }
    
    deinit {
        cancellable?.cancel()
    }
}
    
struct CompanyListScreen: View {
    
    @ObservedObject var viewModel: CompanyListViewModel
    
    init(viewModel: CompanyListViewModel = CompanyListViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.companyList) { company in
                    NavigationLink(destination: EditCompanyScreen(viewModel: EditCompanyViewModel(company: company, mode: .edit))) {
                        ComponeyCellView(company: company)
                    }
                }
            }
            .listRowSpacing(16)
        }
        .navigationTitle("Company List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(destination: EditCompanyScreen(viewModel: EditCompanyViewModel(mode: .create))) {
                   Text("Add")
                }
            }
        }
    }
}

#Preview {
    CompanyListScreen()
}

struct ComponeyCellView: View {
    
    var company: Company
    
    var body: some View {
        VStack {
            HStack {
                Text("Company Name:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(company.name ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            HStack {
                Text("GST:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(company.gstNumber ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            
            HStack {
                Text("Address:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(company.address?.city ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Text(company.address?.state ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            
            HStack {
                Text("Bank name:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(company.bankInfo?.bankName ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            
            HStack {
                Text("Account Number:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(company.bankInfo?.accountNumber ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            
            HStack {
                Text("IFSC code:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(company.bankInfo?.ifscCode ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
        }
        .padding(10)
    }
}
