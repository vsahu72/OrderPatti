//
//  AppIconView.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 24/08/24.
//

import SwiftUI

struct ComponeyHeaderView: View {
    var companyName: String
    var body: some View {
        HStack{
            Image(systemName: "text.book.closed")
                .foregroundColor(.whiteColor)
                .font(.systemFontTitle2)
            
            Text(companyName)
                .foregroundColor(.whiteColor)
                .fontWeight(.bold)
                .titleStyle()
            Spacer()
        }.padding(.top, 40)
    }
}
