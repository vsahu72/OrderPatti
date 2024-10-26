//
//  Utils.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 22/09/24.
//

import Foundation

struct Utils {
    static func generateUniqueId() -> String {
        return Date().toString(formate: .toMilisecond)
    }
}
