//
//  MockClient.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import Foundation

final class MockClient: MovieClientProtocol {
    private let pageSize: Int
    private let totalPages: Int
    private let emptyCategories: Set<MovieCategory>
    private let failingCategories: Set<MovieCategory>
    private let responseDelayNanoseconds: UInt64
    
    init(
        pageSize: Int = 20,
        totalPages: Int = 3,
        emptyCategories: Set<MovieCategory> = [],
        failingCategories: Set<MovieCategory> = [],
        responseDelayNanoseconds: UInt64 = 300_000_000
    ) {
        self.pageSize = pageSize
        self.totalPages = totalPages
        self.emptyCategories = emptyCategories
        self.failingCategories = failingCategories
        self.responseDelayNanoseconds = responseDelayNanoseconds
    }
    
    func fetchGenres() async throws {
        try await delayIfNeeded()
    }
    
    func fetchMovies(by category: MovieCategory, page: Int) async throws -> MoviePage {
        try await delayIfNeeded()
        
        if failingCategories.contains(category) {
            throw NetworkError.requestFailed(MockClientError.forcedFailure)
        }
        
        if emptyCategories.contains(category) {
            return MoviePage(
                movies: [],
                page: 1,
                totalPages: 1,
                totalResults: 0
            )
        }
        
        let safePage = min(max(page, 1), totalPages)
        let movies = (0..<pageSize).map { index in
            makeMovie(category: category, page: safePage, index: index)
        }
        
        return MoviePage(
            movies: movies,
            page: safePage,
            totalPages: totalPages,
            totalResults: pageSize * totalPages
        )
    }
    
    private func makeMovie(category: MovieCategory, page: Int, index: Int) -> Movie {
        let number = ((page - 1) * pageSize) + index + 1
        let providerID = category.providerIDBase + number
        
        return Movie(
            providerID: providerID,
            title: "\(category.rawValue) Movie \(number)",
            overview: "Mock overview for \(category.rawValue.lowercased()) movie \(number).",
            iconURL: URL(string: "https://picsum.photos/seed/\(providerID)/500/750"),
            genres: genres(for: index)
        )
    }
    
    private func genres(for index: Int) -> [String] {
        let genreSets = [
            ["Action", "Adventure"],
            ["Drama", "Mystery"],
            ["Comedy", "Family"],
            ["Sci-Fi", "Thriller"],
            ["Animation", "Fantasy"]
        ]
        
        return genreSets[index % genreSets.count]
    }
    
    private func delayIfNeeded() async throws {
        guard responseDelayNanoseconds > 0 else { return }
        try await Task.sleep(nanoseconds: responseDelayNanoseconds)
    }
}
private enum MockClientError: Error {
    case forcedFailure
}

private extension MovieCategory {
    var providerIDBase: Int {
        switch self {
        case .popular:
            return 10_000
        case .nowPlaying:
            return 20_000
        case .upcoming:
            return 30_000
        }
    }
}

