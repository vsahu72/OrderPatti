//
//  OrderPattiApp.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 20/08/24.
//

import SwiftUI
import FirebaseCore

@main
struct OrderPattiApp: App {
    
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
        TabViewScreen()
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

      FirebaseApp.configure()
      return true
  }
}

