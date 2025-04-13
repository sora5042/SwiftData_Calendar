//
//  SwiftUIExtension.swift
//  Calendar
//
//  Created by Sora Oya on 2025/04/08.
//

import SwiftUI

extension View {
    @ViewBuilder
    func _sheet<Item, Content>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item: Identifiable, Content: View {
        if #available(iOS 18.0, *) {
            sheet(item: item, onDismiss: onDismiss) { item in
                content(item)
                    .presentationSizing(.page)
            }
        } else {
            sheet(item: item, onDismiss: onDismiss) { item in
                content(item)
            }
        }
    }
}

// MARK: - Binding

extension Binding where Value == Bool {
    init(value: Binding<(some Any)?>) {
        self.init(
            get: {
                value.wrappedValue != nil
            },
            set: {
                if !$0 {
                    value.wrappedValue = nil
                }
            }
        )
    }
}
