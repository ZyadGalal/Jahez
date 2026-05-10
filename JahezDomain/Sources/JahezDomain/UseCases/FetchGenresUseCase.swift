//
//  FetchGenresUseCase.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public protocol FetchGenresUseCase {
    func execute() async throws -> [GenreEntity]
}
