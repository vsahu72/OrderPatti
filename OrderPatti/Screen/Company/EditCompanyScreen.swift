//
//  EditCompanyScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 03/09/24.
//

import SwiftUI

struct EditCompanyScreen: View {
    @ObservedObject var viewModel: EditCompanyViewModel
    
    init(viewModel: EditCompanyViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Form {
                general
                address
                bankInfo
                clearAll
            }
            .navigationTitle("Componey Information")
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

extension EditCompanyScreen {
    var general: some View {
        Section {
            TextField("Componey Name", text: $viewModel.name)
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

extension EditCompanyScreen {
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

extension EditCompanyScreen {
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
            Text("Bank Info")
        }.headerProminence(.increased)
    }
}

extension EditCompanyScreen {
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

#Preview {
    EditCompanyScreen(viewModel: EditCompanyViewModel(mode: .create))
}

class EditCompanyViewModel: ObservableObject {
    
    var companyManager: CompanyManager = CompanyManagerImpl.shared
    
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
    
    @Published var createdDate: String = ""
    @Published var modifiedDate: String = ""
    
    @Published var states: [String] = ["Madhya Pradesh", "Uttar Pradesh", "Mumbai", "Jharkhand", "Chhatisgardh"]
    @Published var accountTypes: [String] = ["Current", "Saving"]
    var mode: ScreenDisplayMode
    var company: Company?
    
    
    var isValid: Bool {
        !name.isEmpty &&
        !city.isEmpty &&
        !state.isEmpty &&
        !bankName.isEmpty &&
        !accountNumber.isEmpty &&
        !accountType.isEmpty &&
        !ifscCode.isEmpty
    }
    
    init(company: Company? = nil, mode: ScreenDisplayMode) {
        self.mode = mode
        self.company = company
        if mode == .edit, let company = company {
            setupValue(company: company)
        }
    }
    
    private func setupValue(company: Company) {
        name = company.name ?? ""
        gstNumber = company.gstNumber ?? ""
        
        address1 = company.address?.address1 ?? ""
        area = company.address?.area ?? ""
        city = company.address?.city ?? ""
        state = company.address?.state ?? ""
        
        bankName = company.bankInfo?.bankName ?? ""
        accountNumber = company.bankInfo?.accountNumber ?? ""
        accountType = company.bankInfo?.accountType ?? ""
        ifscCode = company.bankInfo?.ifscCode ?? ""
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
        let componey = Company(id: Utils.generateUniqueId(), createdDate: Date(), modifiedDate: Date(), name: name, gstNumber: gstNumber, address: address, bankInfo: bankInfo)
        Task { [componey] in
            do {
                try await companyManager.createCompany(company: componey)
            } catch {
               print("Error =\(error)")
            }
        }
      
    }
    
    private func update(){
        if !isValid { return }
        let address = Address(id: (company?.address?.id)!, address1: address1, area: area, city: city, state: state)
        let bankInfo = BankInfo(id: (company?.bankInfo?.id)!, bankName: bankName, accountNumber: accountNumber, ifscCode: ifscCode, accountType: accountType)
        let componey = Company(id: (company?.id)!, createdDate: company?.createdDate, modifiedDate: Date(), name: name, gstNumber: gstNumber, address: address, bankInfo: bankInfo)
        Task { [componey] in
            do {
                try await companyManager.updateCompany(company: componey)
            } catch {
               print("Error =\(error)")
            }
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

enum ScreenDisplayMode {
    case edit
    case create
    case display
}

