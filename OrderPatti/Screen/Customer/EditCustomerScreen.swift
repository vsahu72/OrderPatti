//
//  EditCustomerScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 08/09/24.
//

import SwiftUI
import Combine


class EditCustomerViewModel: ObservableObject {
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    var customerManager: CustomerManager = CustomerManagerImpl.shared
    
    @Published var name: String = ""
    @Published var gstNumber: String = ""
    
    @Published var address1: String = ""
    @Published var area: String = ""
    @Published var city: String = ""
    @Published var state: String = "Madhya Pradesh"
    
    @Published var bankName: String = ""
    @Published var accountNumber: String = ""
    @Published var accountType: String = "Current"
    @Published var ifscCode: String = ""
    
    @Published var states: [String] = ["Madhya Pradesh", "Uttar Pradesh", "Mumbai", "Jharkhand", "Chhatisgardh"]
    @Published var accountTypes: [String] = ["Current", "Saving"]
    var mode: ScreenDisplayMode
    var customer: Customer?
    
    var isValid: Bool {
        !name.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty
    }
    
    init(customer: Customer? = nil, mode: ScreenDisplayMode) {
        self.mode = mode
        self.customer = customer
        if mode == .edit, let customer = customer {
            setupValue(customer: customer)
        }
    }
    
    func setupValue(customer: Customer) {
        name = customer.name ?? ""
        gstNumber = customer.gstNumber ?? ""
        
        address1 = customer.address?.address1 ?? ""
        area = customer.address?.area ?? ""
        city = customer.address?.city ?? ""
        state = customer.address?.state ?? ""
        
        bankName = customer.bankInfo?.bankName ?? ""
        accountNumber = customer.bankInfo?.accountNumber ?? ""
        accountType = customer.bankInfo?.accountType ?? ""
        ifscCode = customer.bankInfo?.ifscCode ?? ""
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
        let address = Address(id: Utils.generateUniqueId(), address1: address1, area: area, city: city, state: state)
        let bankInfo = BankInfo(id: Utils.generateUniqueId(), bankName: bankName, accountNumber: accountNumber, ifscCode: ifscCode, accountType: accountType)
        let newCustomer = Customer(id: Utils.generateUniqueId(), createdDate: Date(), modifiedDate: Date(), name: name, gstNumber: gstNumber, address: address, bankInfo: bankInfo)
        Task { [newCustomer] in
            do {
                try await customerManager.createCustomer(customer: newCustomer)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
      
    }
    
    private func update(){
        if !isValid { return }
        let address = Address(id: (customer?.address?.id ?? ""), address1: address1, area: area, city: city, state: state)
        let bankInfo = BankInfo(id: (customer?.bankInfo?.id ?? ""), bankName: bankName, accountNumber: accountNumber, ifscCode: ifscCode, accountType: accountType)
        let updatedCustomer = Customer(id: (customer?.id)!, createdDate: customer?.createdDate, modifiedDate: Date(), name: name, gstNumber: gstNumber, address: address, bankInfo: bankInfo)
        Task { [updatedCustomer] in
            do {
                try await customerManager.updateCustomer(customer: updatedCustomer)
                goBack()
            } catch {
               print("Error =\(error)")
            }
        }
    }
    
    func deleat() {
        guard let customerId = customer?.id else { return }
        
        Task { [customerId] in
            do {
                try await customerManager.deleteCustomer(customerId: customerId)
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
        name = ""
        gstNumber = ""
        
        address1 = ""
        area = ""
        city = ""
        state = ""
        
        bankName = ""
        accountNumber = ""
        accountType = ""
        ifscCode = ""
    }
}

struct EditCustomerScreen: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: EditCustomerViewModel
    
    init(viewModel: EditCustomerViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Form {
                general
                address
                bankInfo
                clearAll
                if viewModel.mode == .edit {
                    delete
                }
             
            }.onReceive(viewModel.viewDismissalModePublisher) { shouldPop in
                if shouldPop {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Add Customer")
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

extension EditCustomerScreen {
    var general: some View {
        Section {
            TextField("Customer Name", text: $viewModel.name)
                .textContentType(.organizationName)
                .keyboardType(.namePhonePad)
            
            TextField("(Optional) GST No.", text: $viewModel.gstNumber)
                .textContentType(.none)
                .keyboardType(.asciiCapableNumberPad)
        } header: {
            Text("General")
        }.headerProminence(.increased)
    }
}

extension EditCustomerScreen {
    var address: some View {
        Section {
            TextField("(Optional) Address 1", text: $viewModel.address1)
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
            
        } header: {
            Text("Address")
        }.headerProminence(.increased)
    }
}

extension EditCustomerScreen {
    var selectProduct1: some View {
        Section {
            Picker("Select product to add", selection: $viewModel.state) {
                ForEach(viewModel.states, id: \.self) { item in
                    Text(item)
                }
            }.pickerStyle(.navigationLink)
            
        } header: {
            Text("Address")
        }.headerProminence(.increased)
    }
}

extension EditCustomerScreen {
    var product: some View {
        Section {
            Picker("Select product", selection: $viewModel.state) {
                ForEach(viewModel.states, id: \.self) { item in
                    Text(item)
                }
            }.pickerStyle(.navigationLink)
            
            TextField("Price", text: $viewModel.city)
                .textContentType(.streetAddressLine1)
                .keyboardType(.namePhonePad)
            
        } header: {
            Text("Address")
        }.headerProminence(.increased)
    }
}

extension EditCustomerScreen {
    var bankInfo: some View {
        Section {
            TextField("Bank name", text: $viewModel.bankName)
                .keyboardType(.namePhonePad)
            
            TextField("Account number", text: $viewModel.accountNumber)
                .keyboardType(.numberPad)
            
            Picker("Account type", selection: $viewModel.accountType) {
                ForEach(viewModel.accountTypes, id: \.self) { item in
                    Text(item)
                }
            }.pickerStyle(.menu)
            
            TextField("IFSC code", text: $viewModel.ifscCode)
                .keyboardType(.asciiCapableNumberPad)
            
        } header: {
            Text("(Optional) Bank Info")
        }.headerProminence(.increased)
    }
}

extension EditCustomerScreen {
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

extension EditCustomerScreen {
    var selectProduct: some View {
        Section {
            Button("Select product to add", role: .none) {
                withAnimation {
                    viewModel.clearAll()
                }
            }
        }
    }
}

extension EditCustomerScreen {
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
    EditCustomerScreen(viewModel: EditCustomerViewModel(customer: nil, mode: .create))
}
