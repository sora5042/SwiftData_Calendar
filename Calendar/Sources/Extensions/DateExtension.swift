//
//  DateExtension.swift
//  Calendar
//
//  Created by Sora Oya on 2025/04/07.
//

import Foundation

extension Date {
    init?(string: String, format: String) {
        guard let date = DateFormatter(dateFormat: format).date(from: string) else {
            return nil
        }
        self = date
    }

    func format(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        formatted(dateFormat)
    }

    func formatted(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    convenience init(calendar: Calendar.Identifier, locale: Locale = .init(identifier: "en_US_POSIX")) {
        self.init()
        self.calendar = .init(identifier: calendar)
        self.locale = locale
    }

    convenience init(dateFormat: String) {
        self.init(calendar: .gregorian)
        self.dateFormat = dateFormat
    }
}
