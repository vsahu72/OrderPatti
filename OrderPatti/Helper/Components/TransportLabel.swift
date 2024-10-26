//
//  TransportLabel.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI

struct TransportLabel: View {
    var isTrasport: Bool
    var address: String
    var body: some View {
        HStack {
            Image(systemName: isTrasport ? "truck.box" : "building.2")
            Text(address)
            Spacer()
        }.padding(.horizontal,5)
    }
}


#Preview {
    TransportLabel(isTrasport: false, address: "Indore")
        .padding()
}
