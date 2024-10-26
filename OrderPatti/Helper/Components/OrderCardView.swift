//
//  OrderCardView.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI

struct OrderCardView: View {
    @ObservedObject var viewModel: OrderItemCellViewModel
    
    init(viewModel: OrderItemCellViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            headerView()
            if viewModel.isExpanded {
                bodyView()
            }
        }
        .background(Rectangle().fill(Color.white).shadow(radius: 2))
        .border(getBackgroundColor(status: viewModel.status), width: 2)
    }
    
    func getBackgroundColor(status: String) -> Color {
        return OrderStatusType.getColor(status: status)
    }
}

extension OrderCardView {
    
    @ViewBuilder func headerView() -> some View {
        VStack {
            VStack {
                HStack{
                    CircularLabel(text: viewModel.customerIconName)
                    VStack (alignment: .leading, spacing: 2){
                        CardTitleLabel(title: viewModel.customerName)
                        IconLabel(text: viewModel.customerLocation)
                    }
                    Spacer()
                    ExpandableButtonView(isExpanded: $viewModel.isExpanded,color: .themeColor, action: {})
                }
            }
        }.padding(12)
    }
    
    @ViewBuilder func bodyView() -> some View {
        VStack {
            Divider()
            VStack {
                ForEach(viewModel.products) { product in
                    withAnimation(.linear) {
                        ProductView(viewModel: OrderProductViewModel(orderItem: product))
                    }
                }
            }
            .padding(.horizontal, 12)
            Divider()
            TransportLabel(isTrasport: viewModel.isTransport, address: viewModel.deliveryAddress)
            StatusLabel(status: viewModel.status)
        }
    }
}


#Preview {
    OrderCardView(viewModel: OrderItemCellViewModel(order: MockData().getSingleOrderDetails()))
        .padding()
}
