//
//  AllMoviesView.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import SwiftUI

struct AllMoviesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var model: AllMoviesViewModel
    @FocusState private var focusedMovieID: Movie.ID?
    
    private let category: MovieCategory
    private let columns = [
        GridItem(.adaptive(minimum: 300), spacing: 24)
    ]
    
    init(category: MovieCategory, clientEndpoint: MovieClientEndpoint) {
        self.category = category
        _model = StateObject(
            wrappedValue: AllMoviesViewModel(category: category, clientEndpoint: clientEndpoint)
        )
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.card)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(model.movies) { movie in
                    MovieCardView(movie: movie, mode: .small, isFocused: focusedMovieID == movie.id)
                        .frame(width: 300, height: 400)
                        .focusable(true)
                        .focused($focusedMovieID, equals: movie.id)
                        .task {
                            await model.loadMoreIfNeeded(currentMovie: movie)
                        }
                }
                
                if model.isLoadingMore {
                    ProgressView()
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                }
                
                if let errorMessage = model.errorMessage, !model.movies.isEmpty {
                    retryView(message: errorMessage)
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue)
        .overlay {
            if model.isLoadingInitialPage {
                ProgressView()
            } else if let errorMessage = model.errorMessage, model.movies.isEmpty {
                retryView(message: errorMessage)
                    .padding()
            } else if model.movies.isEmpty {
                Text("No movies in this category.")
                    .font(.title2)
            }
        }
        .task {
            await model.loadInitialPageIfNeeded()
        }
    }
    
    private func retryView(message: String) -> some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.title3)
            
            Button {
                Task {
                    await model.retry()
                }
            } label: {
                Label("Retry", systemImage: "arrow.clockwise")
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.card)
        }
        .frame(maxWidth: .infinity)
    }
}
