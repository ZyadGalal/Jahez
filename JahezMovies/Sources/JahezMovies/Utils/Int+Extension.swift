//
//  Int+Extension.swift
//  JahezMovies
//
//  Created by Zyad Galal on 10/05/2026.
//

import Foundation

extension Int {
    func getFormattedAmount() -> String {
        self.formatted(.currency(code: "USD"))
    }
}
