//
//  MovieSectionView.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation
import SwiftUI

enum MovieSectionState: Equatable {
    case loading
    case empty
    case ready([Movie])
    case error(String)
}

enum MovieViewMode {
    case large
    case medium
    case small
    
    func size() -> CGSize {
        switch self {
        case .large:
            return CGSize(width: 600, height: 500)
        case .medium:
            return CGSize(width: 400, height: 500)
        case .small:
            return CGSize(width: 300, height: 400)
        }
    }
}

struct MovieSectionView: View {
    let category: MovieCategory
    let mode: MovieViewMode
    @Binding var state: MovieSectionState
    var focusedMovieID: FocusState<Movie.ID?>.Binding
    let onRetry: () async -> Void
    
    var body: some View {
        HStack {
            Text(category.rawValue)
                .font(.headline)
            
            Spacer()
        }
        
        switch state {
        case .loading:
            Button { } label: {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.card)
            
        case .empty:
            Button { } label: {
                Text("No movies in this category.")
                    .font(.title2)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.card)
            
        case .ready(let movies):
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0.0) {
                    ForEach(movies) { movie in
                        MovieCardView(movie: movie, mode: mode, isFocused: focusedMovieID.wrappedValue == movie.id)
                            .frame(width: mode.size().width, height: mode.size().height)
                            .focusable(true)
                            .focused(focusedMovieID, equals: movie.id)
                            .padding()
                    }
                    
                    NavigationLink(value: category) {
                        Label("Show All", systemImage: "square.grid.2x2")
                            .font(.headline)
                            .frame(width: 220, height: mode.size().height)
                    }
                    .buttonStyle(.card)
                    .padding()
                }
            }
            .frame(alignment: .leading)
            
        case .error(let message):
            VStack(spacing: 20) {
                
                Text(message)
                    .font(.title3)
                
                Button {
                    Task {
                        await onRetry()
                    }
                } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.card)
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
        }
    }
}
