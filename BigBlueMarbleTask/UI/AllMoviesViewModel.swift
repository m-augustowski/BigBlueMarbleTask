//
//  AllMoviesViewModel.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import Foundation
import Combine

@MainActor
final class AllMoviesViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoadingInitialPage = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var errorMessage: String?
    
    private let category: MovieCategory
    private let clientEndpoint: MovieClientEndpoint
    private var currentPage = 0
    private var totalPages = 1
    private var hasLoadedInitialPage = false
    
    init(category: MovieCategory, clientEndpoint: MovieClientEndpoint) {
        self.category = category
        self.clientEndpoint = clientEndpoint
    }
    
    var canLoadMore: Bool {
        currentPage < totalPages
    }
    
    func loadInitialPageIfNeeded() async {
        guard !hasLoadedInitialPage else { return }
        hasLoadedInitialPage = true
        await loadPage(1, isInitialPage: true)
    }
    
    func loadMoreIfNeeded(currentMovie: Movie) async {
        guard currentMovie.id == movies.last?.id else { return }
        guard canLoadMore, !isLoadingMore, !isLoadingInitialPage else { return }
        await loadPage(currentPage + 1, isInitialPage: false)
    }
    
    func retry() async {
        if movies.isEmpty {
            hasLoadedInitialPage = false
            await loadInitialPageIfNeeded()
        } else if canLoadMore {
            await loadPage(currentPage + 1, isInitialPage: false)
        }
    }
    
    private func loadPage(_ page: Int, isInitialPage: Bool) async {
        errorMessage = nil
        if isInitialPage {
            isLoadingInitialPage = true
        } else {
            isLoadingMore = true
        }
        
        defer {
            isLoadingInitialPage = false
            isLoadingMore = false
        }
        
        do {
            let moviePage = try await clientEndpoint.client.fetchMovies(by: category, page: page)
            currentPage = moviePage.page
            totalPages = moviePage.totalPages
            movies.append(contentsOf: moviePage.movies.filter { movie in
                !movies.contains(where: { $0.providerID == movie.providerID })
            })
        } catch {
            errorMessage = message(for: error)
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
