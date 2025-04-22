//
//  UICalendarWrapper.swift
//  Calendar
//
//  Created by Sora Oya on 2025/04/09.
//

import SwiftUI
import UIKit

struct UICalendarWrapper: UIViewRepresentable {
    @Binding
    var selectedDates: Set<DateComponents>
    var onSelected: (_ dateComponents: DateComponents) -> Void

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selectionBehavior
        calendarView.locale = .init(identifier: "ja_JP")
        if let initialDate = selectedDates.first {
            selectionBehavior.setSelected(initialDate, animated: false)
        }
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context _: Context) {
        guard let selectionBehavior = uiView.selectionBehavior as? UICalendarSelectionSingleDate else { return }
        if let selectedDate = selectedDates.first {
            selectionBehavior.setSelected(selectedDate, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICalendarSelectionSingleDateDelegate {
        var parent: UICalendarWrapper

        init(_ parent: UICalendarWrapper) {
            self.parent = parent
        }

        func dateSelection(_: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents = dateComponents else { return }
            Task {
                parent.selectedDates = [dateComponents]
                parent.onSelected(dateComponents)
            }
        }
    }
}
