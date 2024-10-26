//
//  TextComponents.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 22/08/24.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .foregroundColor(.darkGrey)
    }
}



extension View {
    
    func titleStyle() -> some View {
        ModifiedContent(content: self, modifier: TitleModifier())
    }
    
}


   
