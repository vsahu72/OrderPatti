//
//  String+Extension.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 23/09/24.
//

import Foundation

extension String {
    func toDecimal() -> Decimal {
        return NumberFormatter().number(from: self)?.decimalValue ?? 0.0
    }
}
