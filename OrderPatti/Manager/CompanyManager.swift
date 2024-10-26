//
//  CompanyManager.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 07/09/24.
//

import Foundation
import FirebaseFirestore
import Combine

protocol CompanyManager {
    var companyListUpdates: AnyPublisher<[Company]?, APIError> { get }
    var primaryCompanyUpdate: AnyPublisher<Company?, APIError> { get }
    func createCompany(company: Company) async throws
    func getCompanyList() async throws -> [Company]
    func getCompany(companyId: String) async throws -> Company
    func updateCompany(company: Company) async throws
}

final class CompanyManagerImpl: CompanyManager {
    
    static var shared = CompanyManagerImpl()
    private init() {
        observeCompanyList()
    }
    
    private let companyCollection = Firestore.firestore().collection("company")
    private var listener: ListenerRegistration?
    private let companyListPublisher = CurrentValueSubject<[Company]?, APIError>(nil)
    private let primaryCompany = CurrentValueSubject<Company?, APIError>(nil)
    
    var companyListUpdates: AnyPublisher<[Company]?, APIError> {
        return companyListPublisher.eraseToAnyPublisher()
    }
    
    var primaryCompanyUpdate: AnyPublisher<Company?, APIError> {
        return primaryCompany.eraseToAnyPublisher()
    }
    
    private func companyDocument(companyId: String) -> DocumentReference {
        companyCollection.document(companyId)
    }
    
    func createCompany(company: Company) async throws {
        let document = companyCollection.document()
        let newCompany = Company(id: document.documentID, createdDate: company.createdDate,name: company.name, address: company.address, bankInfo: company.bankInfo)
        try document.setData(from: newCompany, merge: false)
    }
    
    func getCompany(companyId: String) async throws -> Company {
        try await companyDocument(companyId: companyId).getDocument(as: Company.self)
    }
    
    func updateCompany(company: Company) async throws {
        try companyDocument(companyId: company.id).setData(from: company, merge: true)
    }
    
    private func getAllCompanyQuery() -> Query {
        companyCollection
    }
    
    private func getAllCompanySortedByName(descending: Bool) -> Query {
        companyCollection
            .order(by: Company.CodingKeys.name.rawValue, descending: descending)
    }
    
    func getCompanyList() async throws -> [Company] {
        return try await getAllCompanyQuery().getAllDocuments()
    }
    
    private func setPrimaryCompany(comapanyList: [Company]) {
        guard let firstCompany = comapanyList.first else { return }
        primaryCompany.send(firstCompany)
    }
    
    private func observeCompanyList() {
        let companyStream = companyCollection.addSnapshotStream(as: [Company].self) { listener in
            self.listener = listener
        }
        Task {
            do {
                for try await companylist in companyStream {
                    setPrimaryCompany(comapanyList: companylist)
                    companyListPublisher.send(companylist)
                }
            } catch {
                companyListPublisher.send(completion: .failure(.uploadFailed))
            }
        }
    }
    
    private func stopListening() {
        listener?.remove()
    }
    
    deinit {
        stopListening()
    }
}

enum APIError: Swift.Error {
    case uploadFailed
    case somthingWentWrong
}
