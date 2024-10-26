//
//  OrderDetailsScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 26/08/24.
//

import SwiftUI

struct OrderDetailsScreen: View {
    @ObservedObject var viewModel: OrderDetailsViewModel
    @Environment(\.presentationMode) private var presentationMode
    @State var showProductView = false
    private let gridRows = [
        GridItem(.flexible(minimum: 50, maximum: 200))
    ]
    
    init(viewModel: OrderDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                CustomerHeaderView(viewModel: viewModel)
                   
                StatusView(status: $viewModel.selectedOrderStatus, mode: $viewModel.mode)
                    .zIndex(1000)
                ScrollView {
                    DeliveryView(viewModel: viewModel)
                   if viewModel.mode == .display {
                        CreatedAndModifiedTimeView(createdDate: viewModel.createdDate,
                                                   modifiedDate: viewModel.modifiedDate)
                    }
                   
                    
                    
                    if viewModel.mode != .display {
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: gridRows, spacing: 10)  {
                                ForEach(viewModel.productSuggestionList, id: \.self) { item in
                                    VStack {
                                        Text(item.product?.name ?? "")
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(nil)
                                        Text("\(item.quantity ?? 0)")
                                    }
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: .themeColor, radius: 2)
                                    .onTapGesture {
                                        viewModel.suggestionCellAction(suggestion: item)
                                    }
                                }.padding(10)
                            }
                        }
                    }
                   
                    
                    OrderItemsCellView(viewModel: viewModel)
                   
                    if viewModel.mode != .display {
                        HStack {
                            Spacer()
                            Button(action: { showProductView.toggle() }, label: {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Add")
                                }
                                .frame(width: 100)
                                .padding(10)
                                .font(.title2)
                                .foregroundColor(.themeColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.themeColor, lineWidth: 2)
                                )
                            }).sheet(isPresented: $showProductView) {
                                viewModel.getAddProductView()
                            }
                        }.padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {viewModel.executeAction()}, label: {
                        HStack {
                            Spacer()
                            Text(viewModel.getExecuteActionTitle())
                            Spacer()
                        }
                        .padding(10)
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Color.themeColor)
                            .clipShape(Capsule())
                        
                    }).padding(.horizontal)
                    
                    if viewModel.mode == .edit {
                        Button(action: {viewModel.deleat()}, label: {
                            HStack {
                                Spacer()
                                Text("Delete")
                                Spacer()
                            }
                            .padding(10)
                                .font(.title2)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .clipShape(Capsule())
                            
                        }).padding(.horizontal)
                    }
                    
                }
                
                
                
                
            }.onReceive(viewModel.viewDismissalModePublisher) { shouldPop in
                if shouldPop {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
extension OrderDetailsScreen {
    struct OrderItemsCellView: View {
        @ObservedObject var viewModel: OrderDetailsViewModel
        @State var showProductView = false
        init(viewModel: OrderDetailsViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            VStack(alignment: .leading){
                Text("ITEMS")
                ForEach(viewModel.orderItems) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                //Text("\(index)").bold()
                                
                                if viewModel.mode != .display {
                                    Button(action: { viewModel.removedOrderItem(item: item)}) {
                                        Image(systemName: "archivebox")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                        
                                    }
                                }
                                Text(item.productName ?? "")
                                Spacer()
                                Text("X")
                                    .foregroundColor(.gray)
                                Text("\(item.quantity ?? 0) \(item.unit ?? "")")
                                getImage(status: item.orderItemStatus)
                                if viewModel.mode != .display {
                                    Button(action: { showProductView.toggle() }) {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.themeColor)
                                        
                                    }
                                }
                            }
                        }
                        
                    }.sheet(isPresented: $showProductView) {
                        viewModel.getAddProductView(orderItem: item)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 2)
                }
            }.padding(10)
        }
        
        @ViewBuilder func getImage(status: String?) -> some View {
            switch status {
            case OrderStatusType.orderPlaced.rawValue:
               Image(systemName: "shippingbox")
                    .foregroundColor(.gray)
            case OrderStatusType.preparing.rawValue:
                Image(systemName: "clock")
                     .foregroundColor(.orange)
            case OrderStatusType.ready.rawValue:
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.blue)
            case OrderStatusType.deliver.rawValue:
                Image(systemName: "box.truck")
                    .foregroundColor(.purple)
            case OrderStatusType.cancel.rawValue:
                Image(systemName: "multiply.circle.fill")
                     .foregroundColor(.red)
            default:
                 EmptyView()
            }
        }
    }
}

extension OrderDetailsScreen {
    struct StatusView: View {
        @Binding var status: String?
        @Binding var mode: ScreenDisplayMode
        var body: some View {
            if mode != .create {
                HStack {
                    Spacer()
                    Text(status ?? OrderStatusType.orderPlaced.rawValue)
                    if mode == .edit {
                        DropDownPicker(
                            selection: $status,
                            options: OrderStatusType.allCases.map({ $0.rawValue })
                        )
                    }
                    Spacer()
                }
                .padding(10)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .background(OrderStatusType.getColor(status: status))
            }
        }
    }
}

extension OrderDetailsScreen {
    
    struct DeliveryView: View {
        @ObservedObject var viewModel: OrderDetailsViewModel
        var body: some View {
            VStack {
                if viewModel.mode == .display {
                    HStack {
                        if viewModel.selectedDeliveryOption == .transport {
                            Label(viewModel.selectedTransportAddress?.address1 ?? "None", systemImage: "truck.box")
                            Spacer()
                        } else {
                            Label("Deliver to shop", systemImage: "building.2")
                            Spacer()
                        }
                        
                    }
                   
                } else {
                    DeliverySegmentedControl(selectedOption: $viewModel.selectedDeliveryOption)
                    
                    if viewModel.selectedDeliveryOption == .transport {
                        Divider()
                            .padding()
                        HStack {
                            Text("Address:")
                            Picker("", selection: $viewModel.selectedTransportAddress) {
                                Text("None").tag(nil as Address?)
                                ForEach(viewModel.transportList, id: \.self) { address in
                                    Text(address.address1 ?? "").tag(address as Address?)
                                }
                            }
                            .pickerStyle(.navigationLink)
                            .foregroundColor(.theme)
                            .navigationTitle("Transport Address")
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.theme)
                        }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .themeColor, radius: 2)
            .padding(10)
        }
    }
}
extension OrderDetailsScreen {
    struct CreatedAndModifiedTimeView: View {
        var createdDate: Date?
        var modifiedDate: Date?
        var body: some View {
            HStack {
                Label(createdDate?.toString(formate: .fullTime) ?? "", systemImage: "clock")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(color: .green, radius: 2)
                
                Spacer()
                
                Label(modifiedDate?.toString(formate: .fullTime) ?? "", systemImage: "clock")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(.white)
                    .clipShape(Capsule())
                    .shadow(color: .orange, radius: 2)
            
            }.padding(.horizontal,10)
        }
    }
}

#Preview {
    OrderDetailsScreen(viewModel: OrderDetailsViewModel(orderDetails: nil, displayMode: .display))
}

struct CustomerHeaderView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var viewModel: OrderDetailsViewModel
    @State private var isPresented = false
    
    init(viewModel: OrderDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack{
            VStack (alignment: .center,spacing: 0){
                HStack (spacing: 2){
                    ZStack {
                        HStack {
                            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(.white)
                                    .font(.callout)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                        
                        HStack (spacing: 2){
                            Text(viewModel.customerName.isEmpty ? "Select Customer" : viewModel.customerName)
                                .foregroundColor(.whiteColor)
                                .fontWeight(.bold)
                                .titleStyle()
                                
                            
                            
                            Button(action: {
                                self.isPresented.toggle()
                            }) {
                                Image(systemName: $viewModel.mode.wrappedValue == .display  ? "info.circle" : "chevron.down.circle")
                                    .foregroundColor(.white)
                                    .font(.callout)
                                    .fontWeight(.bold)
                            } .sheet(isPresented: $isPresented) { SearchCustomerScreen(viewModel: SearchCustomerViewModel(), onDismiss: { customer in
                                viewModel.updateCustomerInformation(customer: customer)
                            })}
                        }
                    }
                }
                CustomerAddressLabel(address: viewModel.customerLocation)
                HStack {
                    if viewModel.mode == .display {
                        Text($viewModel.selectedDate.wrappedValue.toString(formate: .dayMonthYear))
                            .foregroundStyle(.white)
                    } else {
                        DatePickerView(selectedDate: $viewModel.selectedDate)
                    }
                    Spacer()
                    if viewModel.mode != .create {
                        EditButtonView(mode: $viewModel.mode, action: {
                            viewModel.updateMode(mode: viewModel.mode == .edit ? .display : .edit)
                        })
                    }
                }.padding(.top)
            }
            Spacer()
        }
        .padding(.bottom)
        .padding(.leading)
        .background(Color.theme)
        .onAppear {
            if viewModel.mode == .create && viewModel.customerName.isEmpty {
                self.isPresented.toggle()
            }
        }
    }
}


struct CustomerAddressLabel: View {
    var address: String
    var body: some View {
        HStack(spacing: 2) {
            Image("location", variableValue: 5)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .foregroundColor(.whiteColor)
            Text(address)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.whiteColor)
            
        }
    }
}

struct EditButtonView: View {
    @Binding var mode: ScreenDisplayMode
    let action: () -> Void
    var body: some View {
        Button(action: action, label: {
            Image(systemName: mode == .display ? "square.and.pencil" : "square.and.pencil.circle.fill")
                .foregroundColor(.whiteColor)
                .font(.systemFontTitle2)
        })
    }
}

import SwiftUI

struct ProductPickerView: View {
    @Binding var selectedOption: Product?
    var options: [Product]
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option // Ensure the state is properly updated
                }) {
                    HStack {
                        Text(option.name ?? "") // Display product name
                        if option == selectedOption {
                            Spacer()
                            Image(systemName: "checkmark") // Display a checkmark if selected
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedOption?.name ?? "None") // Show selected product or "None" if not selected
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .padding(.trailing, 16)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .contentShape(Rectangle()) // Ensures entire area is tappable
    }
}
