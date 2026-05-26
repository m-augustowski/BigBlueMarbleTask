//
//  TMDBClient.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation

final class TMDBClient: MovieClientProtocol {
    private let baseUrl: URL = URL(string: "https://api.themoviedb.org/3/movie")!
    private let token: String
    
    init() {
        self.token = SecretsProvider.tmdbApiToken
    }
    
    func fetchMovies(by category: MovieCategory) async throws -> [Movie] {
        let url = baseUrl.appendingPathComponent(category.urlPathComponent())
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.badStatusCode(httpResponse.statusCode)
            }
            
            do {
                let decoded = try JSONDecoder().decode(TMDBResponse.self, from: data)
                
                let movies = decoded.results.map { Movie(tbdbMovie: $0)  }
                
                return movies
            } catch {
                throw NetworkError.decodingFailed(error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

//MARK: - Helpers
private extension MovieCategory {
    func urlPathComponent() -> String {
        switch self {
        case .popular:
            return "popular"
        case .nowPlaying:
            return "now_playing"
        case .upcoming:
            return "upcoming"
        }
    }
}

private extension Movie {
    init(tbdbMovie: TMDBMovie) {
        self.init(
            title: tbdbMovie.title,
            overview: tbdbMovie.overview,
            iconURL: tbdbMovie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500/\($0)") }
        )
    }
}
