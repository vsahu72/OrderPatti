//
//  TabViewScreen.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 08/09/24.
//

import SwiftUI

struct TabViewScreen: View {
    @State private var selectedIndex: Int = 0
    var componyManager = CompanyManagerImpl.shared
    var productManager = ProductManagerImpl.shared
    var productSuggestionManager = ProductSuggestionManagerImpl.shared
    var body: some View {
        TabView(selection: $selectedIndex) {
            NavigationStack() {
                OrderListScreen(viewModel: OrderDetailsListViewModel())
            }
            .tabItem {
                Text("Orders")
                Image(systemName: "book")
                    .renderingMode(.template)
            }
            .tag(0)
            
            NavigationStack() {
                FeatureListScreen()
                    .navigationTitle("Profile")
            }
            .tabItem {
                Label("Company", systemImage: "building.2")
            }
            .tag(1)
            
            NavigationStack() {
                Text("Settings")
                    .navigationTitle("Settings")
                
            }
            .tabItem {
                Text("Settings")
                Image(systemName: "gear")
            }
            .tag(2)
        }
        //1
        .tint(.theme)
        .onAppear(perform: {
            //2
            UITabBar.appearance().unselectedItemTintColor = .gray
            //3
            UITabBarItem.appearance().badgeColor = .systemPink
            //4
            UITabBar.appearance().backgroundColor = .systemGray4.withAlphaComponent(0.4)
            //5
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.theme]
            //UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
            //Above API will kind of override other behaviour and bring the default UI for TabView
        })
    }
}

#Preview {
    TabViewScreen()
}
