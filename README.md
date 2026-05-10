# JahezTask – TMDB Movies (SwiftUI + Combine)

A production-quality, modular iOS app that browses **trending movies** from
The Movie Database (TMDB). Built with **SwiftUI**, **Combine**, **MVVM** and
**Clean Architecture**, with offline-first caching, infinite scrolling,
local search, multi-select genre filtering.

---

## Features

### Trending list
- Discover endpoint, sorted by popularity.
- Infinite scrolling (auto-fetches the next page when scrolling near the bottom).
- Each row shows poster, title, release year, rating and overview.
- **Local** search bar — filters the already-loaded movies by title.
- **Multi-select** genre chips fetched from TMDB; filtering is performed locally.
- Pull-to-refresh.

### Movie details
- Loaded on tap by movie id.
- Title, large poster, release date (year + month), genres, overview, homepage,
  budget, revenue, spoken languages, status, runtime.

### Architecture
- **`JahezDomain`** — (Domain Layer) contains `entities`, `repository protocols`, `use case protocols`, `DomainError`.
- **`JahezCentral`** — (Domain Layer) contains the implementation of the domain, mapping DTOs to Entities
- **`JahezData`** — (Data layer) contains `DTOs`, `endpoints`,`APIClient`, `Core Data-backed storage`
- **`JahezMovies`** — (Presentation layer) contains `viewModels` and `view`, `Router protocol`
- **`JahezTask` (app target)** contains `AppConfiguration`, `Router implementation`

### Offline support
- Successful responses are written to a **Core Data**. Repositories
  `read`/`write` directly through the `KeyValueStorage` protocol with
  string keys (`movies_page_<n>`, `movie_details_<id>`, `genres_list`).
- When a request fails (offline, timeout, server error, etc.) the
  repository transparently falls back to the cached value if one exists.
