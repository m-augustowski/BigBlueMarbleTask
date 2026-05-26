//
//  MovieClientProtocol.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation

protocol MovieClientProtocol {
    func fetchMovies(by category: MovieCategory) async throws -> [Movie]
}

