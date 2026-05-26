//
//  TMDBClient.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation

final class TMDBClient: MovieClientProtocol {
    private let baseUrl: URL = URL(string: "https://api.themoviedb.org/3")!
    private let token: String
    
    private var genreByIdCached: [Int: String] = [:]
    
    init() {
        self.token = SecretsProvider.tmdbApiToken
    }
    
    func fetchMovies(by category: MovieCategory) async throws -> [Movie] {
        let url = baseUrl
            .appendingPathComponent("movie")
            .appendingPathComponent(category.urlPathComponent())
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoded: TMDBMoviesResponse = try await executeAndDecode(request)
        let movies = decoded.results.map { Movie(tmdbMovie: $0, genreById: genreByIdCached)  }
        return movies
    }
    
    func fetchGenres() async throws {
        let url = baseUrl.appendingPathComponent("genre/movie/list")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoded: TMDBMovieGenresResponse = try await executeAndDecode(request)
        self.genreByIdCached = Dictionary(
            uniqueKeysWithValues: decoded.genres.map { ($0.id, $0.name) }
        )
    }
    
    private func executeAndDecode<T: Codable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.badStatusCode(httpResponse.statusCode)
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
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
    init(tmdbMovie: TMDBMovie, genreById: [Int: String]) {
        self.init(
            title: tmdbMovie.title,
            overview: tmdbMovie.overview,
            iconURL: tmdbMovie.posterPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w500/\($0)") },
            genres: tmdbMovie.genreIds.compactMap { genreById[$0] }
        )
    }
}
