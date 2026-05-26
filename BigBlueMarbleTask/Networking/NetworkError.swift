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

    case requestTimedOut
    case noInternetConnection
    case hostNotFound
    case cannotConnectToHost
    
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
