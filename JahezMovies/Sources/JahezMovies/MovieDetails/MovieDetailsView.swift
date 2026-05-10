//
//  MovieDetailsView.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import SwiftUI
import JahezDomain

@MainActor
public struct MovieDetailsView<ViewModel: MovieDetailsViewModelType>: View {

    @StateObject private var viewModel: ViewModel
    private let imageURLBuilder: ImageURLBuilding

    public init(
        viewModel: ViewModel,
        imageURLBuilder: ImageURLBuilding
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.imageURLBuilder = imageURLBuilder
    }

    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading details…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failed(let message):
                ErrorStateView(message: message, retry: { viewModel.load() })
            case .empty, .loaded:
                if let details = viewModel.details {
                    content(details)
                } else {
                    EmptyView()
                }
            }
        }
        .navigationTitle(viewModel.details?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await MainActor.run {
                viewModel.load()
            }
        }
    }

    @ViewBuilder
    private func content(_ details: MovieDetailsEntity) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header(details)
                Divider()
                if !details.overview.isEmpty {
                    section(title: "Overview") {
                        Text(details.overview)
                            .font(.body)
                    }
                }
                if !details.genres.isEmpty {
                    section(title: "Genres") {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 100), spacing: 10)],
                            spacing: 10
                        ) {
                            ForEach(details.genres) { genre in
                                GenreListItem(genre: genre)
                            }
                        }
                    }
                }
                section(title: "Information") {
                    InfoGrid(details: details)
                }
                if let homepage = details.homepage {
                    section(title: "Homepage") {
                        Link(destination: homepage) {
                            Label(homepage.absoluteString, systemImage: "link")
                                .font(.footnote)
                                .lineLimit(1)
                        }
                    }
                }

                if let spokenLanguages = details.spokenLanguages {
                    section(title: "Spoken Languages"){
                        Text(spokenLanguages)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
        }
    }

    private func header(_ details: MovieDetailsEntity) -> some View {
        HStack(alignment: .top, spacing: 16) {
            PosterImageView(url: imageURLBuilder.largePosterURL(for: details.posterPath))
                .frame(width: 140, height: 210)
            VStack(alignment: .leading, spacing: 8) {
                Text(details.title)
                    .font(.title2.bold())
                    .lineLimit(3)
                if let date = details.releaseDate {
                    Label(date, systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !details.status.isEmpty {
                    Label(details.status, systemImage: "checkmark.seal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let runtime = details.formattedRuntime {
                    Label(runtime, systemImage: "clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content()
        }
    }
}

private struct InfoGrid: View {
    let details: MovieDetailsEntity

    var body: some View {
        let rows: [(String, String)] = [
            ("Status", details.status.isEmpty ? "—" : details.status),
            ("Runtime", details.formattedRuntime ?? "—"),
            ("Budget", "\(details.budget.getFormattedAmount())"),
            ("Revenue", "\(details.revenue.getFormattedAmount())"),
            ("Release", details.releaseDate ?? "—")
        ]
        VStack(spacing: 8) {
            ForEach(rows, id: \.0) { row in
                HStack {
                    Text(row.0)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(row.1)
                        .font(.subheadline.weight(.semibold))
                }
            }
        }
    }
}
