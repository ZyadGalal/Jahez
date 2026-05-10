//
//  ViewState.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case failed(message: String)

    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    public var errorMessage: String? {
        if case .failed(let message) = self { return message }
        return nil
    }
}
