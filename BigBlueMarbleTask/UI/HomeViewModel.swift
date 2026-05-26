//
//  HomeViewModel.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    private let clientEndpoint: MovieClientEndpoint
    
    @Published var popularMoviesState: MovieSectionState = .loading
    @Published var nowPlayingMoviesState: MovieSectionState = .loading
    @Published var upcomingMoviesState: MovieSectionState = .loading
    
    init(clientEndpoint: MovieClientEndpoint) {
        self.clientEndpoint = clientEndpoint
    }
    
    func load() async {
        let _ = try? await clientEndpoint.client.fetchGenres()
        
        await loadMovies(category: .popular, state: \.popularMoviesState)
        await loadMovies(category: .nowPlaying, state: \.nowPlayingMoviesState)
        await loadMovies(category: .upcoming, state: \.upcomingMoviesState)
    }
    
    private func loadMovies(
        category: MovieCategory,
        state: ReferenceWritableKeyPath<HomeViewModel, MovieSectionState>
    ) async {
        self[keyPath: state] = .loading
        
        do {
            let movies = try await clientEndpoint.client.fetchMovies(by: category)
            
            if movies.isEmpty {
                self[keyPath: state] = .empty
            } else {
                self[keyPath: state] = .ready(movies)
            }
        } catch {
            self[keyPath: state] = .error(message(for: error))
        }
    }
    
    private func message(for error: Error) -> String {
        switch error {
        case NetworkError.badStatusCode(401):
            return "Invalid TMDB API token."
        case NetworkError.badStatusCode(let code):
            return "Server error: \(code)"
        case NetworkError.invalidURL:
            return "Invalid request URL."
        case NetworkError.decodingFailed:
            return "Could not read server response."
        default:
            return "Something went wrong. Please try again."
        }
    }
}
