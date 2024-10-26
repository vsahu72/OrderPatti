//
//  IphoneView.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 25/08/24.
//

import SwiftUI

struct IphoneView<Content: View>: View {
    var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        if idiom == .phone {
            content()
        } else {
            EmptyView()
        }
    }
}
