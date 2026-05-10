//
//  ObservableObject+Binding.swift
//  JahezMovies
//

import SwiftUI

extension ObservableObject {
    /// Bridges a settable property on a protocol-typed `ObservableObject` to
    /// a SwiftUI `Binding`. Use this when the view is generic over an I/O
    /// protocol (e.g. `MoviesListViewModelType`) that exposes inputs as
    /// `var x: T { get set }` instead of the concrete `@Published var x`.
    ///
    /// ```swift
    /// .searchable(text: viewModel.binding(\.searchText), prompt: "…")
    /// ```
    func binding<Value>(
        _ keyPath: ReferenceWritableKeyPath<Self, Value>
    ) -> Binding<Value> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
