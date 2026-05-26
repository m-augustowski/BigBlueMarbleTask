//
//  MovieClientNetworkError.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(Int)
    case decodingFailed(Error)
    case requestFailed(Error)
}
