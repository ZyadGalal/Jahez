//
//  DateFormatters.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

extension DateFormatter {

    static let yearMonth: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return formatter
    }()
}
