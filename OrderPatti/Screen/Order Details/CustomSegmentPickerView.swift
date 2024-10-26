//
//  CustomSegmentPickerView.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 03/10/24.
//
//
import SwiftUI

enum DeliveryOptions: String, CaseIterable {
    case shop = "Shop"
    case transport = "Transport"
    
    func backgroundColor() -> Color {
        switch self {
        case .shop:
            return .blue
        case .transport:
            return .green
        }
    }
}

struct DeliverySegmentedControl: View {
    @Binding var selectedOption: DeliveryOptions
    @Environment(\.colorScheme) var colorScheme
    var backgroundColorSegmentedControl: Color {
        return colorScheme == .dark ? .gray.opacity(0.4) : .gray.opacity(0.14)
    }
    var selectedButtonBackgroundColor: Color {
        return .themeColor
    }
    
    var body: some View {
        HStack {
            ForEach(DeliveryOptions.allCases, id: \.self) { option in
                let isSelected = selectedOption == option
                
                Button {
                    selectedOption = option
                } label: {
                    HStack {
                        Image(systemName: option == .shop ? "building.2" : "box.truck")
                        Text(option.rawValue)
                            .padding(.trailing, 20)
                    }
                }
                .bold(isSelected)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .font(.system(size: 20))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .background(isSelected ? selectedButtonBackgroundColor : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .padding(.vertical, 2)
                .padding(.horizontal, 2)
                .shadow(color: isSelected ? .secondary : .clear, radius: 2, y: 1)
            }
        }
        .background(backgroundColorSegmentedControl)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


#Preview {
    DeliverySegmentedControl(selectedOption: .constant(.shop))
        .padding()
}
