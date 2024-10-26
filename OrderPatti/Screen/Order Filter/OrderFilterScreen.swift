



import Foundation
import Combine
import SwiftUI

// MARK: - Models for Filters
struct FilterModel {
    var selectedBrands: Set<String> = []
    var priceSortOption: String? = nil
    var selectedDeliveryType: String? = nil
    var selectedModels: Set<String> = []
    var priceRange: CustomRange<Double> = CustomRange(lowerBound: 1000, upperBound: 10000)
    var dateRange: CustomRange<Date> = CustomRange(lowerBound: Date(), upperBound: Calendar.current.date(byAdding: .day, value: 30, to: Date())!)
}

enum FilterType: String, CaseIterable {
    case brand = "Brands"
    case price = "Sort by Price"
    case delivery = "Delivery Type"
    case model = "Models"
    case priceRange = "Price Range"
    case dateRange = "Date Range"
}

class FilterViewModel: ObservableObject {
    // Published properties for each filter option
    @Published var filterModel = FilterModel()
    @Published var selectedFilterType: FilterType = .brand
    
    // Sample data for filters
    let brands = ["Nike", "Adidas", "Puma", "Reebok"]
    let models = ["Model A", "Model B", "Model C"]
    let sortOptions = ["Low to High", "High to Low"]
    let deliveryOptions = ["Home", "Office"]
    
    // Actions
    func clearFilters() {
        filterModel = FilterModel() // Reset model to defaults
    }
    
    func applyFilters() {
        // Perform action with current filters (e.g., send to server, etc.)
        print("Apply Filters: \(filterModel.selectedBrands), \(filterModel.priceSortOption ?? "None"), \(filterModel.selectedDeliveryType ?? "None"), \(filterModel.selectedModels), \(filterModel.priceRange), \(filterModel.dateRange)")
    }
}


import SwiftUI

struct FilterScreenView: View {
    // Inject ViewModel
    @StateObject private var viewModel = FilterViewModel()
    
    var body: some View {
        HStack {
            // Left Side: Filter Categories
            VStack(alignment: .leading) {
                ForEach(FilterType.allCases, id: \.self) { filter in
                    Text(filter.rawValue)
                        .padding()
                        .background(viewModel.selectedFilterType == filter ? Color.blue.opacity(0.2) : Color.clear)
                        .onTapGesture {
                            viewModel.selectedFilterType = filter
                        }
                }
                Spacer()
                
                // Clear and Apply Buttons
                HStack {
                    Button(action: viewModel.clearFilters) {
                        Text("Clear")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action: viewModel.applyFilters) {
                        Text("Apply")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .frame(width: 150)
            .background(Color.gray.opacity(0.1))
            
            // Right Side: Filter Options
            VStack {
                switch viewModel.selectedFilterType {
                case .brand:
                    BrandFilterView(selectedBrands: $viewModel.filterModel.selectedBrands, brands: viewModel.brands)
                case .price:
                    PriceSortView(selectedOption: $viewModel.filterModel.priceSortOption, sortOptions: viewModel.sortOptions)
                case .delivery:
                    DeliveryTypeView(selectedDeliveryType: $viewModel.filterModel.selectedDeliveryType, deliveryOptions: viewModel.deliveryOptions)
                case .model:
                    ModelFilterView(selectedModels: $viewModel.filterModel.selectedModels, models: viewModel.models)
                case .priceRange:
                    PriceRangeView(priceRange: $viewModel.filterModel.priceRange)
                case .dateRange:
                    DateRangeView(dateRange: $viewModel.filterModel.dateRange)
                }
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    FilterScreenView()
}


struct BrandFilterView: View {
    @Binding var selectedBrands: Set<String>
    let brands: [String]
    
    var body: some View {
        List(brands, id: \.self) { brand in
            HStack {
                Text(brand)
                Spacer()
                if selectedBrands.contains(brand) {
                    Image(systemName: "checkmark")
                }
            }
            .onTapGesture {
                if selectedBrands.contains(brand) {
                    selectedBrands.remove(brand)
                } else {
                    selectedBrands.insert(brand)
                }
            }
        }
    }
}

struct PriceSortView: View {
    @Binding var selectedOption: String?
    let sortOptions: [String]
    
    var body: some View {
        List(sortOptions, id: \.self) { option in
            HStack {
                Text(option)
                Spacer()
                if selectedOption == option {
                    Image(systemName: "checkmark")
                }
            }
            .onTapGesture {
                selectedOption = option
            }
        }
    }
}

struct DeliveryTypeView: View {
    @Binding var selectedDeliveryType: String?
    let deliveryOptions: [String]
    
    var body: some View {
        List(deliveryOptions, id: \.self) { option in
            HStack {
                Text(option)
                Spacer()
                if selectedDeliveryType == option {
                    Image(systemName: "checkmark")
                }
            }
            .onTapGesture {
                selectedDeliveryType = option
            }
        }
    }
}

struct ModelFilterView: View {
    @Binding var selectedModels: Set<String>
    let models: [String]
    
    var body: some View {
        List(models, id: \.self) { model in
            HStack {
                Text(model)
                Spacer()
                if selectedModels.contains(model) {
                    Image(systemName: "checkmark")
                }
            }
            .onTapGesture {
                if selectedModels.contains(model) {
                    selectedModels.remove(model)
                } else {
                    selectedModels.insert(model)
                }
            }
        }
    }
}

struct CustomRange<T> {
    var lowerBound: T
    var upperBound: T
}

struct PriceRangeView: View {
    @Binding var priceRange: CustomRange<Double>
    
    
    
    var body: some View {
        VStack {
            Text("Price Range: \(Int(priceRange.lowerBound)) - \(Int(priceRange.upperBound))")
            Slider(value: $priceRange.lowerBound, in: 1000...priceRange.upperBound)
            Slider(value: $priceRange.upperBound, in: priceRange.lowerBound...10000)
        }
    }
}

struct DateRangeView: View {
    @Binding var dateRange: CustomRange<Date>
    
    var body: some View {
        VStack {
            DatePicker("Start Date", selection: $dateRange.lowerBound, displayedComponents: .date)
            DatePicker("End Date", selection: $dateRange.upperBound, displayedComponents: .date)
        }
    }
}


public protocol PrinceRange: Equatable & Hashable {
  var name: String {get set}
  var upperBound: Int {get set}
  var lowerBound: Int {get set}
  init(_ name: String, bounds: ClosedRange<Int>)
}

public extension PrinceRange {
    var bound: ClosedRange<Int> {
        get { lowerBound...upperBound }
        set {
            lowerBound = newValue.lowerBound
            upperBound = newValue.upperBound
        }
    }
}
