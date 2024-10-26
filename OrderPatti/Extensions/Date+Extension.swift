//
//  Date+Extension.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 22/09/24.
//

import Foundation

extension Date {
    func toString(formate: DateFormaterType) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat =  formate.rawValue
        return formatter.string(from: self)
    }
    
    var onlyDate: Date {
          get {
              let calender = Calendar.current
              var dateComponents = calender.dateComponents([.year, .month, .day], from: self)
              dateComponents.timeZone = NSTimeZone.system
              return calender.date(from: dateComponents) ?? Date()
          }
      }
}

enum DateFormaterType: String {
   case toMilisecond = "yyyy-MM-dd HH:mm:ss.SSS"
   case dayMonthYear = "dd MMM yyyy"
   case fullTime = "dd MMM yyyy HH:mm a"
}
