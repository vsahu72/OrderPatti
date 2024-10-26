//
//  TransportAddressListScreen.swift
//  OrderPatti
//
//  Created by Priyanshu Jaiswal on 06/10/24.
//

import Foundation
import Combine
import SwiftUI

final class TransportAddressViewModel: ObservableObject {
    private let transportAddressManager: TransportAddressManager = TransportAddressManagerImpl.shared
    private var cancellable: AnyCancellable?  // Store the subscription
    
    @Published var trasnportAddressList: [Address] = []
    
    init() {
        loadTransportAddressList()
    }
    
    func loadTransportAddressList() {
        cancellable = transportAddressManager.transportListUpdates
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished receiving values.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { transportAddresses in
                DispatchQueue.main.async { [weak self] in
                    self?.trasnportAddressList.removeAll()
                    self?.trasnportAddressList = transportAddresses ?? []
                }
            })
    }
    
    deinit {
        print("@@@@... deinit")
        cancellable?.cancel()
    }
    
}

struct TransportAddressListScreen: View {
    
    @ObservedObject var viewModel: TransportAddressViewModel
    
    init(viewModel: TransportAddressViewModel = TransportAddressViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.trasnportAddressList) { address in
                    NavigationLink(destination: EditTransportAddressScreen(viewModel: EditTransportAddressViewModel(address: address, mode: .edit))) {
                         TransportAddressCellView(address: address)
                    }
                }
            }
            .id(UUID()) 
            .listRowSpacing(16)
        }
        .navigationTitle("Transport List")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink(destination: EditTransportAddressScreen(viewModel: EditTransportAddressViewModel(address: nil, mode: .create))) {
                   Text("Add")
                }
            }
        }
    }
}

#Preview {
    TransportAddressListScreen()
}

struct TransportAddressCellView: View {
    
    var address: Address
    
    init(address: Address) {
        self.address = address
        print("@@.. address init =\(String(describing: address.address1))")
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text(address.address1 ?? "")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            HStack {
                Text("Address:")
                    .fontWeight(.medium)
                    .foregroundColor(.darkText)
                Text("\(address.area ?? "") | \(address.city ?? "")")
                    .fontWeight(.regular)
                    .foregroundColor(.lightText)
                Spacer()
            }
            
        }
        .padding(10)
    }
}
