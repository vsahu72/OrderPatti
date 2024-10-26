//
//  DatePickerView.swift
//  OrderPatti
//
//  Created by Vikash Sahu on 24/08/24.
//

import SwiftUI

struct DatePickerView: View {
    @State var calendarId: Int = 0
    @Binding var selectedDate: Date
    var didButtonTapped: ((Date) -> Void)? = nil
    var body: some View {
        HStack {
            Button(action: { changeDateBy(-1) }, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.title2)
            })
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .labelsHidden()
                .accentColor(.themeColor)
                .colorInvert()
                .font(.title2)
            Button(action: {changeDateBy(1) }, label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .font(.title2)
            })
        }
    }
    
    func changeDateBy(_ day: Int) {
        if let date = Calendar.current.date(byAdding: .day, value: day, to: selectedDate) {
            self.selectedDate = date
            didButtonTapped?(date)
        }
    }
}
