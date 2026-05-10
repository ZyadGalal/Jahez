//
//  MovieDisplayFormatting.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import JahezDomain


public extension MovieDetailsEntity {

    var formattedRuntime: String? {
        guard let runtime, runtime > 0 else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours == 0 { return "\(minutes)m" }
        if minutes == 0 { return "\(hours)h" }
        return "\(hours)h \(minutes)m"
    }
}
