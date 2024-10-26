//
//  OrderListScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI

struct OrderListScreen: View {
    
    let spacing: CGFloat = 24
    @State var numberOfRows = 1
  //  @State var searchText = ""
  //  @State var date: Date = .now
    @State var isExpanded = true
    @ObservedObject var viewModel: OrderDetailsListViewModel
    
    init(viewModel: OrderDetailsListViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                VStack {
                    ComponeyHeaderView(companyName: viewModel.primaryCompany?.name ?? "Company not present")
                    HStack {
                        DatePickerView(selectedDate: $viewModel.orderDeliveryDate) { date in
                            viewModel.loadOrderDetailsList(for: date)
                        }
                        Spacer()
                        IpadView {
                            SearchBar(text: $viewModel.searchText)
                                .padding(.horizontal)
                        }
                        FilterButtonView(action: { viewModel.showAdvanceFilter.toggle() })
                        ExpandableButtonView(isExpanded: $viewModel.isAllExpanded, action: {viewModel.toggleAllExpansion()})
                        RefreshButtonView(action: {viewModel.reset()})
                    }
                   
                    
                    IphoneView {
                        SearchBar(text: $viewModel.searchText)
                    }
                    
                    IpadView {
                        HStack {
                            Picker("", selection: $viewModel.selectedDeliveryType) {
                                ForEach(DeliveryType.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .frame(width: 220)
                            .pickerStyle(.segmented)
                            Spacer()
                            StatusDropDownPicker(
                                selection: $viewModel.selectedOrderStatus,
                                options: OrderStatusType.allCases)
                            
                        }.padding(.vertical,10)
                    }
                    
                    IphoneView {
                        
                        if viewModel.showAdvanceFilter {
                            HStack {
                                Picker("", selection: $viewModel.selectedDeliveryType) {
                                    ForEach(DeliveryType.allCases, id: \.self) {
                                        Text($0.rawValue)
                                    }
                                }
                                .frame(width: 150)
                                .pickerStyle(.segmented)
                                Spacer()
                                StatusDropDownPicker(
                                    selection: $viewModel.selectedOrderStatus,
                                    options: OrderStatusType.allCases)
                                
                            }.padding(.top,10)
                        }
                     
                    }
                }
                .padding()
                .background(Color.theme)
                .zIndex(1000)
                
                let columns = Array(repeating: GridItem(.flexible(), spacing: spacing, alignment: .top ), count: numberOfRows)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(viewModel.filterOrderDetailsList) { orderViewModel in
                            NavigationLink(destination: NavigationLazyView(OrderDetailsScreen(viewModel: OrderDetailsViewModel(orderDetails: orderViewModel.orderDetails, displayMode: .display)))) {
                                withAnimation(.linear) {
                                    OrderCardView(viewModel: orderViewModel)
                                }
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom,80)
            }
            NavigationLink(destination: NavigationLazyView(OrderDetailsScreen(viewModel: OrderDetailsViewModel(orderDetails: nil, displayMode: .create)))) {
                withAnimation(.linear) {
                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white)
                        .background(Color.themeColor)
                        .clipShape(Circle())
                        .padding()
                        .padding(.bottom, 80)
                }
            }
        }
        .background(Color.listBgColor)
        .ignoresSafeArea()
        .onAppear {
            numberOfRows = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 1
        }
    }
}

#Preview {
    OrderListScreen(viewModel: OrderDetailsListViewModel())
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
