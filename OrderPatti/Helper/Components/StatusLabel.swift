//
//  StatusLabel.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI

struct StatusLabel: View {
    var status: String
    var body: some View {
        HStack {
            Spacer()
            Text(status)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(10)
        .background(getBackgroundColor(status: status))
    }
    
    func getBackgroundColor(status: String) -> Color {
        return OrderStatusType.getColor(status: status)
    }
}
