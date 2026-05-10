//
//  GenreListItem.swift
//  JahezMovies
//
//  Created by Zyad Galal on 09/05/2026.
//

import SwiftUI
import JahezDomain

struct GenreListItem: View {
    let genre: GenreEntity

    var body: some View {
        VStack(spacing: 6) {
            Text(genre.name)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.accentColor.opacity(0.12))
        )
    }
}
