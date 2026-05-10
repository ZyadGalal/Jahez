//
//  MovieRowView.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import SwiftUI
import JahezDomain

struct MovieRowView: View {
    let movie: MovieEntity
    let imageURLBuilder: ImageURLBuilding

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            PosterImageView(url: imageURLBuilder.posterURL(for: movie.posterPath))
                .frame(width: 84, height: 126)

            VStack(alignment: .leading, spacing: 0) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                if let releaseDate = movie.releaseDate {
                    Label(releaseDate, systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if movie.voteAverage > 0 {
                    Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                        .font(.subheadline)
                        .foregroundStyle(.yellow)
                }

                Text(movie.overview)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}
