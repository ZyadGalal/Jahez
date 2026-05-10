//
//  MovieDetailsViewModelType.swift
//  JahezMovies
//

import Foundation
import JahezDomain

@MainActor
public protocol MovieDetailsViewModelType: ObservableObject {
    // Output
    var details: MovieDetailsEntity? { get }
    var state: ViewState { get }

    // Input
    func load()
}
