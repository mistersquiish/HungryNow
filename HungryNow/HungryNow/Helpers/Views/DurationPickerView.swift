//
//  DurationPickerView.swift
//  HungryNow
//
//  Created by Henry Vuong on 4/14/20.
//  Copyright © 2020 Henry Vuong. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct DurationPickerView: UIViewRepresentable {
    @Binding var time: DurationPickerTime

    func makeCoordinator() -> DurationPickerView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.setValue(UIColor(named: "font"), forKeyPath: "textColor")
        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.onDateChanged), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ datePicker: UIDatePicker, context: Context) {
        let date = Calendar.current.date(bySettingHour: time.hour, minute: time.minute, second: time.second, of: datePicker.date)!
        datePicker.setDate(date, animated: true)
    }

    class Coordinator: NSObject {
        var durationPicker: DurationPickerView

        init(_ durationPicker: DurationPickerView) {
            self.durationPicker = durationPicker
            
        }

        @objc func onDateChanged(sender: UIDatePicker) {
            let calendar = Calendar.current
            let date = sender.date
            durationPicker.time = DurationPickerTime(hour: calendar.component(.hour, from: date), minute: calendar.component(.minute, from: date), second: calendar.component(.second, from: date))
        }
    }
}

struct DurationPickerTime {
    var hour: Int
    var minute: Int
    var second: Int = 0
    
    public var description: String {
        return "\(hour)hr \(minute)min"
    }
}
