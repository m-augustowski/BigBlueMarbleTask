//
//  HomeView.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation
import SwiftUI

class HomeViewModel {
    private let clientEndpoint: MovieClientEndpoint
    
    init(clientEndpoint: MovieClientEndpoint) {
        self.clientEndpoint = clientEndpoint
    }
    
    func fetchPopular() async throws -> [Movie] {
        return try await clientEndpoint.client.getPopular()
    }
    
    func fetchMostViewed() async throws -> [Movie] {
        return try await clientEndpoint.client.getMostViewed()
    }
    
    func fetchUpcoming() async throws -> [Movie] {
        return try await clientEndpoint.client.getUpcoming()
    }
}

struct HomeView: View {
    private let model: HomeViewModel
    
    @State var popularMovies: [Movie]? = nil
    @State var mostViewedMovies: [Movie]? = nil
    @State var upcomingMovies: [Movie]? = nil
    
    @FocusState private var focusedMovieID: Movie.ID?
    
    init(clientEndpoint: MovieClientEndpoint) {
        self.model = HomeViewModel(clientEndpoint: clientEndpoint)
    }
    
    var body: some View {
        ScrollView {
            Text("Home View")
                .font(.title)
                .frame(alignment: .leading)
            
            Divider()
            
            MovieSectionView(
                category: .popular,
                movies: $popularMovies,
                focusedMovieID: $focusedMovieID
            )
            
            MovieSectionView(
                category: .mostViewed,
                movies: $mostViewedMovies,
                focusedMovieID: $focusedMovieID
            )
            
            MovieSectionView(
                category: .upcoming,
                movies: $upcomingMovies,
                focusedMovieID: $focusedMovieID
            )
        }
        .task {
            do {
                self.popularMovies = try await model.fetchPopular()
            } catch {
                
            }
        }
        .task {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000 * 10)
                self.mostViewedMovies = try await model.fetchMostViewed()
            } catch {
                
            }
        }
        .task {
            do {
                self.upcomingMovies = try await model.fetchUpcoming()
            } catch {
                
            }
        }
    }
    
}

struct MovieSectionView: View {
    let category: MovieCategory
    @Binding var movies: [Movie]?
    var focusedMovieID: FocusState<Movie.ID?>.Binding
    
    var body: some View {
        HStack {
            Text(category.rawValue)
                .font(.headline)
            
            Spacer()
        }
        
        if let movies {
            if movies.isEmpty {
                Button { } label: {
                    Text("No movies in this category.")
                        .font(.title2)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.card)
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 14.0) {
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
            }
        } else {
            Button { } label: {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.card)
        }
    }
    
}

struct MovieCardView: View {
    let movie: Movie
    let isFocused: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "xmark")
                .frame(height: 260, alignment: .center)
            
            VStack {
                Text(movie.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(movie.description)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            .frame(alignment: .leading)
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20.0)
                .fill(Color(.systemGray))
        )
        .scaleEffect(isFocused ? 1.08 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}
