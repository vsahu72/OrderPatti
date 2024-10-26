//
//  ButtonViews.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 24/08/24.
//

import SwiftUI

struct FilterButtonView: View {
    let action: () -> Void
    var body: some View {
        Button(action: action, label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundColor(.whiteColor)
                .font(.title2)
        })
    }
}

struct RefreshButtonView: View {
    let action: () -> Void
    var body: some View {
        Button(action: action, label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(.whiteColor)
                .font(.systemFontTitle2)
        })
    }
}

struct ExpandableButtonView: View {
    @Binding var isExpanded: Bool
    var color: Color = .whiteColor
    let action: () -> Void
    var body: some View {
        Button(action: {
            isExpanded.toggle()
            action()
        }, label: {
            Image(systemName: isExpanded ? "rectangle.bottomhalf.inset.filled" : "rectangle.tophalf.inset.filled")
                .foregroundColor(color)
                .font(.systemFontTitle2)
        })
    }
}
