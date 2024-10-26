//
//  CircularLabel.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI

struct CircularLabel: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.systemFont18)
            .foregroundColor(.white)
            .bold()
            .padding(10)
            .background(Color.themeColor)
            .clipShape(Circle())
    }
}
