//
//  MovieClientProtocol.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation

protocol MovieClientProtocol {
    func getPopular() async throws -> [Movie]
    func getMostViewed() async throws -> [Movie]
    func getUpcoming() async throws -> [Movie]
}

