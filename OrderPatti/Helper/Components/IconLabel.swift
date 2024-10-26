//
//  IconLabel.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI

struct IconLabel: View {
    var text: String
    var body: some View {
        HStack(spacing: 2) {
            Image("location", variableValue: 5)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .foregroundColor(Color.lightTextColor)
            Text(text)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.lightTextColor)
        }
    }
}
