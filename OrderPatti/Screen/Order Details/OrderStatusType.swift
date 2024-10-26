//
//  OrderStatusType.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 03/10/24.
//

import SwiftUI

enum OrderStatusType: String, CaseIterable {
    case noneType = "None"
    case orderPlaced = "Order Placed"
    case preparing = "Preapring"
    case ready = "Ready"
    case deliver = "Deliver"
    case done = "Done"
    case cancel = "Cancel"
    
    static func getColor(status: String?) -> Color {
        switch status {
        case OrderStatusType.noneType.rawValue:
            return Color.white
        case OrderStatusType.orderPlaced.rawValue:
            return Color.gray
        case OrderStatusType.preparing.rawValue:
            return Color.orange
        case OrderStatusType.ready.rawValue:
            return Color.blue
        case OrderStatusType.deliver.rawValue:
            return Color.purple
        case OrderStatusType.done.rawValue:
            return Color.green
        case OrderStatusType.cancel.rawValue:
            return Color.red
        default:
            return Color.gray
        }
    }
    
    var color : Color {
        switch self {
        case .noneType:
            return .white
        case .orderPlaced:
            return Color.gray
        case .preparing:
            return Color.orange
        case .ready:
            return Color.blue
        case .deliver:
            return Color.purple
        case .done:
            return Color.green
        case .cancel:
            return Color.red
        }
    }
}
