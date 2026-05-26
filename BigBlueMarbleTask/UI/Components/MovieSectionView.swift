//
//  MovieSectionView.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation
import SwiftUI

enum MovieSectionState {
    case loading
    case empty
    case ready([Movie])
    case error(String)
}

struct MovieSectionView: View {
    let category: MovieCategory
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
                    ForEach(movies, id: \.self) { movie in
                        MovieCardView(movie: movie, isFocused: focusedMovieID.wrappedValue == movie.id)
                            .frame(width: 400, height: 500)
                            .focusable(true)
                            .focused(focusedMovieID, equals: movie.id)
                            .padding()
                    }
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
