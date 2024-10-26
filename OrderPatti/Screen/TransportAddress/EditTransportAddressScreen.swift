//
//  EditTransportAddressScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 08/09/24.
//

import SwiftUI
import Combine

struct EditTransportAddressScreen: View {
    @ObservedObject var viewModel: EditTransportAddressViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    init(viewModel: EditTransportAddressViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Form {
                address
                clearAll
                if viewModel.mode == .edit {
                    delete
                }
            }.onReceive(viewModel.viewDismissalModePublisher) { shouldPop in
                if shouldPop {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Transport Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.mode == .create ? "Save" : "Update") {
                        viewModel.execute()
                    }.disabled(!viewModel.isValid)
                }
            }
        }
    }
}


extension EditTransportAddressScreen {
    var address: some View {
        Section {
            TextField("Transport Name", text: $viewModel.transportName)
                .textContentType(.streetAddressLine1)
                .keyboardType(.namePhonePad)
            
            TextField("(Optional) Area", text: $viewModel.area)
                .textContentType(.streetAddressLine1)
                .keyboardType(.namePhonePad)
            
            TextField("City", text: $viewModel.city)
                .textContentType(.streetAddressLine1)
                .keyboardType(.namePhonePad)
            
            Picker("State", selection: $viewModel.state) {
                ForEach(viewModel.states, id: \.self) { item in
                    Text(item)
                }
            }.pickerStyle(.navigationLink)
        }
    }
}

extension EditTransportAddressScreen {
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

extension EditTransportAddressScreen {
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
    EditTransportAddressScreen(viewModel: EditTransportAddressViewModel(address: nil, mode: .create))
}

class EditTransportAddressViewModel: ObservableObject {
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    @Published var transportName: String = ""
    @Published var area: String = ""
    @Published var city: String = ""
    @Published var state: String = "Madhya Pradesh"

    @Published var states: [String] = ["Madhya Pradesh", "Uttar Pradesh", "Mumbai", "Jharkhand", "Chhatishgardh"]
    
    var mode: ScreenDisplayMode = .display
    var transportAddress: Address? = nil
    var transportAddressManager: TransportAddressManager = TransportAddressManagerImpl.shared
    
    var isValid: Bool {
        !transportName.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty
    }
    
    init(address: Address?, mode: ScreenDisplayMode) {
        self.mode = mode
        if mode == .edit, let address = address {
            transportAddress = address
            setupValue(address: address)
        }
    }
    
    func setupValue(address: Address) {
        transportName = address.address1 ?? ""
        area = address.area ?? ""
        city = address.city ?? ""
        state = address.state ?? ""
    }
    
    func execute() {
        if mode == .edit {
            update()
        } else {
            save()
        }
    }
    
    func save(){
        if !isValid { return }
        let newTransportAddress = Address(id: "",
                                          address1: transportName,
                                          area: area,
                                          city: city,
                                          state: state,
                                          country: "India")
        Task { [newTransportAddress] in
            do {
                try await   transportAddressManager.createTransport(address: newTransportAddress)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
        
    }
    
    func update() {
        if !isValid { return }
        guard let transportAddressId = transportAddress?.id else { return }
        let updateTransportAddress = Address(id: transportAddressId,
                                          address1: transportName,
                                          area: area,
                                          city: city,
                                          state: state,
                                          country: "India")
        Task { [updateTransportAddress] in
            do {
                try await   transportAddressManager.updateTransport(address: updateTransportAddress)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
    }
    
    func deleat() {
        guard let transportAddressId = transportAddress?.id else { return }
        
        Task { [transportAddressId] in
            do {
                try await transportAddressManager.deleteTransport(addressId: transportAddressId)
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
        transportName = ""
        area = ""
        city = ""
        state = ""
    }
}
