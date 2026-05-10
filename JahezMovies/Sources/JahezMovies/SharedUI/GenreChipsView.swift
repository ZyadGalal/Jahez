//
//  GenreChipsView.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import SwiftUI
import JahezDomain

struct GenreChipsView: View {
    let genres: [GenreEntity]
    @Binding var selectedGenreIDs: Set<Int>
    var onClear: () -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if !selectedGenreIDs.isEmpty {
                    Button(action: onClear) {
                        Label("Clear", systemImage: "xmark.circle.fill")
                            .labelStyle(.titleAndIcon)
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.secondary.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
                ForEach(genres) { genre in
                    GenreChip(
                        genre: genre,
                        isSelected: selectedGenreIDs.contains(genre.id),
                        onToggle: { toggle(genre) }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(height: 52)
    }

    private func toggle(_ genre: GenreEntity) {
        if selectedGenreIDs.contains(genre.id) {
            selectedGenreIDs.remove(genre.id)
        } else {
            selectedGenreIDs.insert(genre.id)
        }
    }
}

private struct GenreChip: View {
    let genre: GenreEntity
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            Text(genre.name)
                .font(.footnote.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color.secondary.opacity(0.15))
                )
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
