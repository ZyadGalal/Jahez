//
//  MoviesRouting.swift
//  JahezMovies
//
//  Created by Zyad Galal on 09/05/2026.
//

import SwiftUI

public protocol MoviesRouting {
    func movieDetailsView(id: Int) -> AnyView
}
