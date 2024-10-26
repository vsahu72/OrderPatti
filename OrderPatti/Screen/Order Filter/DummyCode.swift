//
//  DummyCode.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 01/10/24.
//
//
//import Foundation
//import Combine
//
//// Define four publishers that can fail with an Error
//let publisher1 = PassthroughSubject<Int, Error>()
//let publisher2 = PassthroughSubject<Int, Error>()
//let publisher3 = PassthroughSubject<Int, Error>()
//let publisher4 = PassthroughSubject<Int, Error>()
//
//// Combine the publishers using combineLatest
//let combined = publisher1
//.combineLatest(publisher2)
//.combineLatest(publisher3)
//.combineLatest(publisher4)
//.map { (arg1, fourth) in
//    let ((first, second), third) = arg1
//    return (first, second, third, fourth)
//}
//
//// Subscribe to the combined publisher
//let cancellable = combined.sink(
//receiveCompletion: { completion in
//    switch completion {
//    case .finished:
//        print("All publishers completed successfully.")
//    case .failure(let error):
//        print("Error encountered: \(error)")
//    }
//},
//receiveValue: { first, second, third, fourth in
//    print("Combined values: \(first), \(second), \(third), \(fourth)")
//}
//)
//
//// Sending some values
//publisher1.send(1)
//publisher2.send(2)
//publisher3.send(3)
//publisher4.send(4)
//
//// Sending an error to simulate a failure
//publisher2.send(completion: .failure(NSError(domain: "TestError", code: 123, userInfo: nil)))
//
//
//
//import SwiftUI
//
//// Model for individual filter options (e.g., a brand or a rating)
//struct FilterOption: Identifiable {
//let id = UUID()
//let name: String
//var isSelected: Bool
//}
//
//// ViewModel for managing filter options
//class FilterViewModel: ObservableObject {
//@Published var brands: [FilterOption]
//@Published var priceRange: ClosedRange<Double> = 0...1000
//@Published var minRating: Int = 1
//
//init() {
//    // Initial sample brands
//    self.brands = [
//        FilterOption(name: "Brand A", isSelected: false),
//        FilterOption(name: "Brand B", isSelected: false),
//        FilterOption(name: "Brand C", isSelected: false)
//    ]
//}
//
//func resetFilters() {
//    brands = brands.map { FilterOption(name: $0.name, isSelected: false) }
//    priceRange = 0...1000
//    minRating = 1
//}
//
//func applyFilters() {
//    // Handle apply logic here (e.g., make network request, filter products)
//}
//}
//
//struct FilterScreen: View {
//@StateObject var viewModel = FilterViewModel()
//
//var body: some View {
//    NavigationView {
//        VStack {
//            List {
//                // Price Range Section
//                Section(header: Text("Price Range")) {
//                    HStack {
//                        Text("Min: \(Int(viewModel.priceRange.lowerBound))")
//                        Spacer()
//                        Text("Max: \(Int(viewModel.priceRange.upperBound))")
//                    }
//                    RangeSlider(range: $viewModel.priceRange, in: 0...1000)
//                }
//                
//                // Brands Section
//                Section(header: Text("Brands")) {
//                    ForEach(viewModel.brands) { brand in
//                        HStack {
//                            Text(brand.name)
//                            Spacer()
//                            if brand.isSelected {
//                                Image(systemName: "checkmark")
//                            }
//                        }
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            toggleBrandSelection(brand: brand)
//                        }
//                    }
//                }
//                
//                // Rating Section
//                Section(header: Text("Minimum Rating")) {
//                    Stepper(value: $viewModel.minRating, in: 1...5) {
//                        Text("\(viewModel.minRating) Stars & Above")
//                    }
//                }
//            }
//            
//            // Apply & Reset Buttons
//            HStack {
//                Button(action: {
//                    viewModel.resetFilters()
//                }) {
//                    Text("Reset")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                }
//                
//                Button(action: {
//                    viewModel.applyFilters()
//                }) {
//                    Text("Apply")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle("Filters")
//    }
//}
//
//private func toggleBrandSelection(brand: FilterOption) {
//    if let index = viewModel.brands.firstIndex(where: { $0.id == brand.id }) {
//        viewModel.brands[index].isSelected.toggle()
//    }
//}
//}
//
//// Custom Range Slider for price range
//struct RangeSlider: View {
//@Binding var range: ClosedRange<Double>
//var bounds: ClosedRange<Double>
//
//var body: some View {
//    VStack {
//        Slider(value: $range.lowerBound, in: bounds.lowerBound...range.upperBound)
//        Slider(value: $range.upperBound, in: range.lowerBound...bounds.upperBound)
//    }
//}
//}
//
//struct FilterScreen_Previews: PreviewProvider {
//static var previews: some View {
//    FilterScreen()
//}
//}
//
//=====================================================================
//import SwiftUI
//
//struct FilterView: View {
//// Filter properties
//@State private var selectedBrands: Set<String> = []
//@State private var selectedModels: Set<String> = []
//@State private var priceSortOption: String = "Low to High"
//@State private var deliveryType: String = "Home"
//@State private var priceRange: ClosedRange<Double> = 0...1000
//@State private var selectedStartDate: Date = Date()
//@State private var selectedEndDate: Date = Date().addingTimeInterval(86400) // One day later
//
//let brands = ["Brand A", "Brand B", "Brand C", "Brand D"]
//let models = ["Model X", "Model Y", "Model Z"]
//
//var body: some View {
//    NavigationView {
//        Form {
//            // Multiple Brand Selection
//            Section(header: Text("Brands")) {
//                ForEach(brands, id: \.self) { brand in
//                    MultipleSelectionRow(title: brand, isSelected: selectedBrands.contains(brand)) {
//                        if selectedBrands.contains(brand) {
//                            selectedBrands.remove(brand)
//                        } else {
//                            selectedBrands.insert(brand)
//                        }
//                    }
//                }
//            }
//            
//            // Sort by Price
//            Section(header: Text("Sort by Price")) {
//                Picker("Sort", selection: $priceSortOption) {
//                    Text("Low to High").tag("Low to High")
//                    Text("High to Low").tag("High to Low")
//                }
//                .pickerStyle(SegmentedPickerStyle())
//            }
//            
//            // Delivery Type
//            Section(header: Text("Delivery Type")) {
//                Picker("Delivery", selection: $deliveryType) {
//                    Text("Home").tag("Home")
//                    Text("Office").tag("Office")
//                }
//                .pickerStyle(SegmentedPickerStyle())
//            }
//            
//            // Multiple Model Selection
//            Section(header: Text("Models")) {
//                ForEach(models, id: \.self) { model in
//                    MultipleSelectionRow(title: model, isSelected: selectedModels.contains(model)) {
//                        if selectedModels.contains(model) {
//                            selectedModels.remove(model)
//                        } else {
//                            selectedModels.insert(model)
//                        }
//                    }
//                }
//            }
//            
//            // Price Range Slider
//            Section(header: Text("Price Range")) {
//                VStack {
//                    Text("Price Range: \(Int(priceRange.lowerBound)) - \(Int(priceRange.upperBound))")
//                    Slider(value: $priceRange, in: 0...1000, step: 10)
//                }
//            }
//            
//            // Date Range
//            Section(header: Text("Date Range")) {
//                DatePicker("Start Date", selection: $selectedStartDate, displayedComponents: .date)
//                DatePicker("End Date", selection: $selectedEndDate, displayedComponents: .date)
//            }
//            
//            // Clear and Apply Buttons
//            Section {
//                HStack {
//                    Button(action: clearFilters) {
//                        Text("Clear")
//                            .foregroundColor(.red)
//                    }
//                    Spacer()
//                    Button(action: applyFilters) {
//                        Text("Apply")
//                            .foregroundColor(.blue)
//                    }
//                }
//            }
//        }
//        .navigationBarTitle("Filters")
//    }
//}
//
//// Clear filters function
//func clearFilters() {
//    selectedBrands.removeAll()
//    selectedModels.removeAll()
//    priceSortOption = "Low to High"
//    deliveryType = "Home"
//    priceRange = 0...1000
//    selectedStartDate = Date()
//    selectedEndDate = Date().addingTimeInterval(86400)
//}
//
//// Apply filters function
//func applyFilters() {
//    // Handle applying filters
//    print("Applying filters with selected options...")
//}
//}
//
//struct MultipleSelectionRow: View {
//var title: String
//var isSelected: Bool
//var action: () -> Void
//
//var body: some View {
//    Button(action: action) {
//        HStack {
//            Text(title)
//            if isSelected {
//                Spacer()
//                Image(systemName: "checkmark")
//            }
//        }
//    }
//}
//}
//
//struct FilterView_Previews: PreviewProvider {
//static var previews: some View {
//    FilterView()
//}
//}
//
//==============================================================================================%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//import SwiftUI
//
//struct FilterScreenView: View {
//// Define states for all filters
//@State private var selectedBrands: Set<String> = []
//@State private var priceSortOption: String? = nil
//@State private var selectedDeliveryType: String? = nil
//@State private var selectedModels: Set<String> = []
//@State private var priceRange: ClosedRange<Double> = 1000...10000
//@State private var dateRange: ClosedRange<Date> = Date()...Calendar.current.date(byAdding: .day, value: 30, to: Date())!
//
//// State for currently selected filter type
//@State private var selectedFilterType: FilterType = .brand
//
//// Mock data for filters
//let brands = ["Nike", "Adidas", "Puma", "Reebok"]
//let models = ["Model A", "Model B", "Model C"]
//
//// Enum for filter type
//enum FilterType: String, CaseIterable {
//    case brand = "Brands"
//    case price = "Sort by Price"
//    case delivery = "Delivery Type"
//    case model = "Models"
//    case priceRange = "Price Range"
//    case dateRange = "Date Range"
//}
//
//var body: some View {
//    HStack {
//        // Left Side: Filter Categories
//        VStack(alignment: .leading) {
//            ForEach(FilterType.allCases, id: \.self) { filter in
//                Text(filter.rawValue)
//                    .padding()
//                    .background(selectedFilterType == filter ? Color.blue.opacity(0.2) : Color.clear)
//                    .onTapGesture {
//                        selectedFilterType = filter
//                    }
//            }
//            Spacer()
//            // Clear and Apply Buttons
//            HStack {
//                Button(action: clearFilters) {
//                    Text("Clear")
//                        .foregroundColor(.red)
//                }
//                Spacer()
//                Button(action: applyFilters) {
//                    Text("Apply")
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding()
//        }
//        .frame(width: 150)
//        .background(Color.gray.opacity(0.1))
//        
//        // Right Side: Filter Options
//        VStack {
//            switch selectedFilterType {
//            case .brand:
//                BrandFilterView(selectedBrands: $selectedBrands, brands: brands)
//            case .price:
//                PriceSortView(selectedOption: $priceSortOption)
//            case .delivery:
//                DeliveryTypeView(selectedDeliveryType: $selectedDeliveryType)
//            case .model:
//                ModelFilterView(selectedModels: $selectedModels, models: models)
//            case .priceRange:
//                PriceRangeView(priceRange: $priceRange)
//            case .dateRange:
//                DateRangeView(dateRange: $dateRange)
//            }
//        }
//        .padding()
//    }
//    .padding()
//}
//
//// MARK: - Actions
//private func clearFilters() {
//    selectedBrands.removeAll()
//    priceSortOption = nil
//    selectedDeliveryType = nil
//    selectedModels.removeAll()
//    priceRange = 1000...10000
//    dateRange = Date()...Calendar.current.date(byAdding: .day, value: 30, to: Date())!
//}
//
//private func applyFilters() {
//    // Perform actions with the selected filters
//    print("Apply Filters: \(selectedBrands), \(priceSortOption ?? "None"), \(selectedDeliveryType ?? "None"), \(selectedModels), \(priceRange), \(dateRange)")
//}
//}
//
//// MARK: - Subviews for Each Filter Option
//
//struct BrandFilterView: View {
//@Binding var selectedBrands: Set<String>
//let brands: [String]
//
//var body: some View {
//    List(brands, id: \.self) { brand in
//        HStack {
//            Text(brand)
//            Spacer()
//            if selectedBrands.contains(brand) {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            if selectedBrands.contains(brand) {
//                selectedBrands.remove(brand)
//            } else {
//                selectedBrands.insert(brand)
//            }
//        }
//    }
//}
//}
//
//struct PriceSortView: View {
//@Binding var selectedOption: String?
//let sortOptions = ["Low to High", "High to Low"]
//
//var body: some View {
//    List(sortOptions, id: \.self) { option in
//        HStack {
//            Text(option)
//            Spacer()
//            if selectedOption == option {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            selectedOption = option
//        }
//    }
//}
//}
//
//struct DeliveryTypeView: View {
//@Binding var selectedDeliveryType: String?
//let deliveryOptions = ["Home", "Office"]
//
//var body: some View {
//    List(deliveryOptions, id: \.self) { option in
//        HStack {
//            Text(option)
//            Spacer()
//            if selectedDeliveryType == option {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            selectedDeliveryType = option
//        }
//    }
//}
//}
//
//struct ModelFilterView: View {
//@Binding var selectedModels: Set<String>
//let models: [String]
//
//var body: some View {
//    List(models, id: \.self) { model in
//        HStack {
//            Text(model)
//            Spacer()
//            if selectedModels.contains(model) {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            if selectedModels.contains(model) {
//                selectedModels.remove(model)
//            } else {
//                selectedModels.insert(model)
//            }
//        }
//    }
//}
//}
//
//struct PriceRangeView: View {
//@Binding var priceRange: ClosedRange<Double>
//
//var body: some View {
//    VStack {
//        Text("Price Range: \(Int(priceRange.lowerBound)) - \(Int(priceRange.upperBound))")
//        Slider(value: $priceRange.lowerBound, in: 1000...priceRange.upperBound)
//        Slider(value: $priceRange.upperBound, in: priceRange.lowerBound...10000)
//    }
//}
//}
//
//struct DateRangeView: View {
//@Binding var dateRange: ClosedRange<Date>
//
//var body: some View {
//    VStack {
//        DatePicker("Start Date", selection: $dateRange.lowerBound, displayedComponents: .date)
//        DatePicker("End Date", selection: $dateRange.upperBound, displayedComponents: .date)
//    }
//}
//}
//
//struct FilterScreenView_Previews: PreviewProvider {
//static var previews: some View {
//    FilterScreenView()
//}
//}
//
//—-------------------------------------------------------------------------444444444444444444444444444444444444444444—-------------------------------------
//
//import Foundation
//
//// MARK: - Models for Filters
//struct FilterModel {
//var selectedBrands: Set<String> = []
//var priceSortOption: String? = nil
//var selectedDeliveryType: String? = nil
//var selectedModels: Set<String> = []
//var priceRange: ClosedRange<Double> = 1000...10000
//var dateRange: ClosedRange<Date> = Date()...Calendar.current.date(byAdding: .day, value: 30, to: Date())!
//}
//
//enum FilterType: String, CaseIterable {
//case brand = "Brands"
//case price = "Sort by Price"
//case delivery = "Delivery Type"
//case model = "Models"
//case priceRange = "Price Range"
//case dateRange = "Date Range"
//}
//
//Vvvvvvvvvvvvvvvvvvvvvvvvvvvvv
//
//import Combine
//import SwiftUI
//
//class FilterViewModel: ObservableObject {
//// Published properties for each filter option
//@Published var filterModel = FilterModel()
//@Published var selectedFilterType: FilterType = .brand
//
//// Sample data for filters
//let brands = ["Nike", "Adidas", "Puma", "Reebok"]
//let models = ["Model A", "Model B", "Model C"]
//let sortOptions = ["Low to High", "High to Low"]
//let deliveryOptions = ["Home", "Office"]
//
//// Actions
//func clearFilters() {
//    filterModel = FilterModel() // Reset model to defaults
//}
//
//func applyFilters() {
//    // Perform action with current filters (e.g., send to server, etc.)
//    print("Apply Filters: \(filterModel.selectedBrands), \(filterModel.priceSortOption ?? "None"), \(filterModel.selectedDeliveryType ?? "None"), \(filterModel.selectedModels), \(filterModel.priceRange), \(filterModel.dateRange)")
//}
//}
//
//Vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
//
//import SwiftUI
//
//struct FilterScreenView: View {
//// Inject ViewModel
//@StateObject private var viewModel = FilterViewModel()
//
//var body: some View {
//    HStack {
//        // Left Side: Filter Categories
//        VStack(alignment: .leading) {
//            ForEach(FilterType.allCases, id: \.self) { filter in
//                Text(filter.rawValue)
//                    .padding()
//                    .background(viewModel.selectedFilterType == filter ? Color.blue.opacity(0.2) : Color.clear)
//                    .onTapGesture {
//                        viewModel.selectedFilterType = filter
//                    }
//            }
//            Spacer()
//            
//            // Clear and Apply Buttons
//            HStack {
//                Button(action: viewModel.clearFilters) {
//                    Text("Clear")
//                        .foregroundColor(.red)
//                }
//                Spacer()
//                Button(action: viewModel.applyFilters) {
//                    Text("Apply")
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding()
//        }
//        .frame(width: 150)
//        .background(Color.gray.opacity(0.1))
//        
//        // Right Side: Filter Options
//        VStack {
//            switch viewModel.selectedFilterType {
//            case .brand:
//                BrandFilterView(selectedBrands: $viewModel.filterModel.selectedBrands, brands: viewModel.brands)
//            case .price:
//                PriceSortView(selectedOption: $viewModel.filterModel.priceSortOption, sortOptions: viewModel.sortOptions)
//            case .delivery:
//                DeliveryTypeView(selectedDeliveryType: $viewModel.filterModel.selectedDeliveryType, deliveryOptions: viewModel.deliveryOptions)
//            case .model:
//                ModelFilterView(selectedModels: $viewModel.filterModel.selectedModels, models: viewModel.models)
//            case .priceRange:
//                PriceRangeView(priceRange: $viewModel.filterModel.priceRange)
//            case .dateRange:
//                DateRangeView(dateRange: $viewModel.filterModel.dateRange)
//            }
//        }
//        .padding()
//    }
//    .padding()
//}
//}
//
//
//
//Vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
//
//
//struct BrandFilterView: View {
//@Binding var selectedBrands: Set<String>
//let brands: [String]
//
//var body: some View {
//    List(brands, id: \.self) { brand in
//        HStack {
//            Text(brand)
//            Spacer()
//            if selectedBrands.contains(brand) {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            if selectedBrands.contains(brand) {
//                selectedBrands.remove(brand)
//            } else {
//                selectedBrands.insert(brand)
//            }
//        }
//    }
//}
//}
//
//struct PriceSortView: View {
//@Binding var selectedOption: String?
//let sortOptions: [String]
//
//var body: some View {
//    List(sortOptions, id: \.self) { option in
//        HStack {
//            Text(option)
//            Spacer()
//            if selectedOption == option {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            selectedOption = option
//        }
//    }
//}
//}
//
//struct DeliveryTypeView: View {
//@Binding var selectedDeliveryType: String?
//let deliveryOptions: [String]
//
//var body: some View {
//    List(deliveryOptions, id: \.self) { option in
//        HStack {
//            Text(option)
//            Spacer()
//            if selectedDeliveryType == option {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            selectedDeliveryType = option
//        }
//    }
//}
//}
//
//struct ModelFilterView: View {
//@Binding var selectedModels: Set<String>
//let models: [String]
//
//var body: some View {
//    List(models, id: \.self) { model in
//        HStack {
//            Text(model)
//            Spacer()
//            if selectedModels.contains(model) {
//                Image(systemName: "checkmark")
//            }
//        }
//        .onTapGesture {
//            if selectedModels.contains(model) {
//                selectedModels.remove(model)
//            } else {
//                selectedModels.insert(model)
//            }
//        }
//    }
//}
//}
//
//struct PriceRangeView: View {
//@Binding var priceRange: ClosedRange<Double>
//
//var body: some View {
//    VStack {
//        Text("Price Range: \(Int(priceRange.lowerBound)) - \(Int(priceRange.upperBound))")
//        Slider(value: $priceRange.lowerBound, in: 1000...priceRange.upperBound)
//        Slider(value: $priceRange.upperBound, in: priceRange.lowerBound...10000)
//    }
//}
//}
//
//struct DateRangeView: View {
//@Binding var dateRange: ClosedRange<Date>
//
//var body: some View {
//    VStack {
//        DatePicker("Start Date", selection: $dateRange.lowerBound, displayedComponents: .date)
//        DatePicker("End Date", selection: $dateRange.upperBound, displayedComponents: .date)
//    }
//}
//}
//
//
//
//import SwiftUI
//
//struct DropdownOption: Hashable {
//    let key: String
//    let value: String
//
//    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
//        return lhs.key == rhs.key
//    }
//}
//
//struct DropdownRow: View {
//    var option: DropdownOption
//    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
//
//    var body: some View {
//        Button(action: {
//            if let onOptionSelected = self.onOptionSelected {
//                onOptionSelected(self.option)
//            }
//        }) {
//            HStack {
//                Text(self.option.value)
//                    .font(.system(size: 14))
//                    .foregroundColor(Color.black)
//                Spacer()
//            }
//        }
//        .padding(.horizontal, 16)
//        .padding(.vertical, 5)
//    }
//}
//
//struct Dropdown: View {
//    var options: [DropdownOption]
//    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 0) {
//                ForEach(self.options, id: \.self) { option in
//                    DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
//                }
//            }
//        }
//        .frame(minHeight: CGFloat(options.count) * 30, maxHeight: 250)
//        .padding(.vertical, 5)
//        .background(Color.white)
//        .cornerRadius(5)
//        .overlay(
//            RoundedRectangle(cornerRadius: 5)
//                .stroke(Color.gray, lineWidth: 1)
//        )
//    }
//}
//
//struct DropdownSelector: View {
//    @State private var shouldShowDropdown = false
//    @State private var selectedOption: DropdownOption? = nil
//    var placeholder: String
//    var options: [DropdownOption]
//    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
//    private let buttonHeight: CGFloat = 45
//
//    var body: some View {
//        Button(action: {
//            self.shouldShowDropdown.toggle()
//        }) {
//            HStack {
//                Text(selectedOption == nil ? placeholder : selectedOption!.value)
//                    .font(.system(size: 14))
//                    .foregroundColor(selectedOption == nil ? Color.gray: Color.black)
//
//                Spacer()
//
//                Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
//                    .resizable()
//                    .frame(width: 9, height: 5)
//                    .font(Font.system(size: 9, weight: .medium))
//                    .foregroundColor(Color.black)
//            }
//        }
//        .padding(.horizontal)
//        .cornerRadius(5)
//        .frame(width: .infinity, height: self.buttonHeight)
//        .overlay(
//            RoundedRectangle(cornerRadius: 5)
//                .stroke(Color.gray, lineWidth: 1)
//        )
//        .overlay(
//            VStack {
//                if self.shouldShowDropdown {
//                    Spacer(minLength: buttonHeight + 10)
//                    Dropdown(options: self.options, onOptionSelected: { option in
//                        shouldShowDropdown = false
//                        selectedOption = option
//                        self.onOptionSelected?(option)
//                    })
//                }
//            }, alignment: .topLeading
//        )
//        .background(
//            RoundedRectangle(cornerRadius: 5).fill(Color.white)
//        )
//    }
//}
//
//struct DropdownSelector_Previews: PreviewProvider {
//    @State private static var address: String = ""
//
//    static var uniqueKey: String {
//        UUID().uuidString
//    }
//
//    static let options: [DropdownOption] = [
//        DropdownOption(key: uniqueKey, value: "Sunday"),
//        DropdownOption(key: uniqueKey, value: "Monday"),
//        DropdownOption(key: uniqueKey, value: "Tuesday"),
//        DropdownOption(key: uniqueKey, value: "Wednesday"),
//        DropdownOption(key: uniqueKey, value: "Thursday"),
//        DropdownOption(key: uniqueKey, value: "Friday"),
//        DropdownOption(key: uniqueKey, value: "Saturday")
//    ]
//
//
//    static var previews: some View {
//        VStack(spacing: 20) {
//            DropdownSelector(
//                placeholder: "Day of the week",
//                options: options,
//                onOptionSelected: { option in
//                    print(option)
//            })
//            .padding(.horizontal)
//            .zIndex(1)
//
//            Group {
//                TextField("Full Address", text: $address)
//                    .font(.system(size: 14))
//                    .padding(.horizontal)
//            }
//            .frame(width: .infinity, height: 45)
//            .overlay(
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
//            .padding(.horizontal)
//        }
//    }
//}
