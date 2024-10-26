//
//  ProductView.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI

struct ProductView : View {
    var viewModel: OrderProductViewModel
  
    var body: some View {
        HStack {
                HStack {
                    
    //                Image(systemName: "checkmark.circle.fill")
    //                    .foregroundColor(.white)
    //                Image(systemName: "clock.badge.checkmark.fill")
    //                    .foregroundColor(.yellow)
                    Circle()
                        .frame(width: 15)
                        .foregroundColor(getBackgroundColor(status: viewModel.status))
                        
                    
                    Text(viewModel.name)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding(.horizontal,5)
                        .foregroundColor(.darkText)
                    Text("x")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.lightText)
                    Text(viewModel.quantity)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding(.horizontal,5)
                        .foregroundColor(.darkText)
                }.padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.lightGrey, lineWidth: 2)
                    )
                Spacer()
            }
    }
    
    @ViewBuilder func getPreparedProduct() -> some View {
        HStack {
            HStack {
                
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
//                Image(systemName: "clock.badge.checkmark.fill")
//                    .foregroundColor(.yellow)
                Text(viewModel.name)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .padding(.horizontal,5)
                Text("x")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.gray)
                Text(viewModel.quantity)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .padding(.horizontal,5)
            }.padding(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.lightGrey, lineWidth: 2)
                )
            Spacer()
        }
    }
    
    func getBackgroundColor(status: String) -> Color {
        switch status {
        case "Order Placed": return .white
        case "Preparing" : return .orange
        case "Ready": return .purple
        case "Deliver" : return .green
        case "Cansel" : return .red
        default: return .pink
        }
    }
}

struct OrderProductViewModel {
    var orderProductId: String
    var name: String
    var quantity: String
    var status: String
    
    init(orderItem: OrderItem){
        orderProductId = orderItem.id
        name = orderItem.productName ?? ""
        quantity = "\(orderItem.quantity ?? 0)"
        status = orderItem.orderItemStatus ?? ""
    }
  
}

#Preview {
    let componey = MockData().getCompneyInfo()
    let product = Product(id: "1", companyID: componey.id, name: "Laddu", mrp: 30.00)
    let orderPrductViewModel = OrderProductViewModel(orderItem: OrderItem(id: "1", productId: "1", productName: "Laddu", quantity: 120, rate: 120, discountedRate: 120, orderItemStatus: "Ready"))
    return ProductView(viewModel: orderPrductViewModel)
        .padding(.horizontal, 120)
}
