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
                            .frame(width: 300, height: 400)
                            .focusable(true)
                            .focused(focusedMovieID, equals: movie.id)
                            .padding()
                    }
                }
            }
            .frame(alignment: .leading)
            
        case .error(let message):
            Button { } label: {
                Text(message)
                    .font(.title2)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.card)
            
        }
        
    }
}
