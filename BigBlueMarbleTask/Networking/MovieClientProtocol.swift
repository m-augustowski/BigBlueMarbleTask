//
//  MovieClientProtocol.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation

protocol MovieClientProtocol {
    func fetchGenres() async throws
    func fetchMovies(by category: MovieCategory, page: Int) async throws -> MoviePage
}

