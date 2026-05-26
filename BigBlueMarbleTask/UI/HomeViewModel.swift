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
        
        await loadMovies(category: .popular)
        await loadMovies(category: .nowPlaying)
        await loadMovies(category: .upcoming)
    }
    
    func retryLoad(for category: MovieCategory) {
        Task {
            await loadMovies(category: category)
        }
    }
    
    private func loadMovies(category: MovieCategory) async {
        let state = category.stateKeyPath
        
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
        case NetworkError.invalidResponse:
            return "Invalid server response."
        case NetworkError.decodingFailed:
            return "Could not read server response."
        case NetworkError.requestTimedOut:
            return "The request timed out. Please try again."
        case NetworkError.noInternetConnection:
            return "No internet connection."
        case NetworkError.hostNotFound:
            return "Server host could not be found."
        case NetworkError.cannotConnectToHost:
            return "Could not connect to the server."
        case NetworkError.requestFailed:
            return "Request failed. Please try again."
        default:
            return "Something went wrong. Please try again."
        }
    }
}

fileprivate extension MovieCategory {
    var stateKeyPath: ReferenceWritableKeyPath<HomeViewModel, MovieSectionState> {
        switch self {
        case .popular:
            return \.popularMoviesState
        case .nowPlaying:
            return \.nowPlayingMoviesState
        case .upcoming:
            return \.upcomingMoviesState
        }
    }
}
