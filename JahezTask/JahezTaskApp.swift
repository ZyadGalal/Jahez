//
//  JahezTaskApp.swift
//  JahezTask
//
//  Created by Zyad Galal on 07/05/2026.
//

import SwiftUI
import JahezMovies
import JahezCentral
import JahezData

@main
struct JahezTaskApp: App {
    
    var body: some Scene {
        WindowGroup {
            MoviesListView(
                viewModel: makeMoviesListViewModel(),
                router: MoviesRouter(),
                imageURLBuilder: ImageURLBuilder()
            )
        }
    }

    private func makeMoviesListViewModel() -> MoviesListViewModel {
        let config = AppConfiguration()
        let storage = CoreDataKeyValueStorage()
        let apiClient = APIClient(
            baseURL: config.baseURL,
            credentials: APICredentials(
                apiKey: config.apiKey,
                bearerToken: config.bearerToken
            )
        )
        let moviesRepo = DefaultMoviesRepository(
            apiClient: apiClient,
            storage: storage
        )
        
        let genresRepo = DefaultGenresRepository(
                    apiClient: apiClient,
                    storage: storage
                )
        
        return MoviesListViewModel(
            fetchMovies: DefaultFetchTrendingMoviesUseCase(repository: moviesRepo),
            fetchGenres: DefaultFetchGenresUseCase(repository: genresRepo),
            networkMonitor: NetworkMonitor()
        )
    }
}
