//
//  MovieDetailsViewModel.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import JahezDomain

@MainActor
public final class MovieDetailsViewModel: MovieDetailsViewModelType {
    
    @Published public private(set) var details: MovieDetailsEntity?
    @Published public private(set) var state: ViewState = .idle
    
    private let movieID: Int
    private let useCase: FetchMovieDetailsUseCase
    
    public init(movieID: Int, useCase: FetchMovieDetailsUseCase) {
        self.movieID = movieID
        self.useCase = useCase
    }
    
    public func load() {
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await self.useCase.execute(movieID: self.movieID)
                self.details = result
                self.state = .loaded
            } catch {
                self.state = .failed(message: error.localizedDescription)
            }
        }
    }
}
