//
//  MoviesRouter.swift
//  JahezTask
//
//  Created by Zyad Galal on 09/05/2026.
//

import SwiftUI
import JahezDomain
import JahezMovies
import JahezCentral
import JahezData

@MainActor
final class MoviesRouter: MoviesRouting {

    func movieDetailsView(id: Int) -> AnyView {
        AnyView(
            MovieDetailsView(
                viewModel: prepareMovieDetailsViewModel(id: id),
                imageURLBuilder: ImageURLBuilder()
            )
        )
    }

    private func prepareMovieDetailsViewModel(id: Int) -> MovieDetailsViewModel {
        let config = AppConfiguration()
        let apiClient = APIClient(
            baseURL: config.baseURL,
            credentials: APICredentials(
                apiKey: config.apiKey,
                bearerToken: config.bearerToken
            )
        )
        let storage = CoreDataKeyValueStorage()
        let moviesRepository = DefaultMoviesRepository(
            apiClient: apiClient,
            storage: storage
        )
        let usecase = DefaultFetchMovieDetailsUseCase(
            repository: moviesRepository
        )
        
        return MovieDetailsViewModel(
            movieID: id,
            useCase: usecase
        )
    }
        
}
