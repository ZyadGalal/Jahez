//
//  PosterImageView.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import SwiftUI

struct PosterImageView: View {
    let url: URL?
    var cornerRadius: CGFloat = 12

    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeInOut(duration: 0.2))) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                placeholder
                    .overlay(
                        Image(systemName: "film")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    )
            default:
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color.secondary.opacity(0.15))
            .overlay(ProgressView())
    }
}
