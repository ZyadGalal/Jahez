//
//  FetchMovieDetailsUseCase.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public protocol FetchMovieDetailsUseCase: Sendable {
    func execute(movieID: Int) async throws -> MovieDetailsEntity
}
