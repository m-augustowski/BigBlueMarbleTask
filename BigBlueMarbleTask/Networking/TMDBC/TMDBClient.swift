//
//  TMDBClient.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation

final class TMDBClient: MovieClientProtocol {
    
    
    init() {
        
    }
    
    func getPopular() async throws -> [Movie] {
        return [
            Movie(name: "movie 1", description: "movie 1 description", iconURL: nil),
            Movie(name: "movie 2", description: "movie 2 description", iconURL: nil),
            Movie(name: "movie 3", description: "movie 3 description", iconURL: nil),
            Movie(name: "movie 4", description: "movie 4 description", iconURL: nil),
            Movie(name: "movie 5", description: "movie 5 description", iconURL: nil),
            Movie(name: "movie 6", description: "movie 6 description", iconURL: nil),
            Movie(name: "movie 7", description: "movie 7 description", iconURL: nil),
            Movie(name: "movie 8", description: "movie 8 description", iconURL: nil),
            Movie(name: "movie 9", description: "movie 9 description", iconURL: nil),
        ]
    }
    
    func getMostViewed() async throws -> [Movie] {
        return [
            Movie(name: "movie 1 most viewed", description: "movie 1 description most viewed", iconURL: nil),
            Movie(name: "movie 2 most viewed", description: "movie 2 description most viewed", iconURL: nil),
            Movie(name: "movie 3 most viewed", description: "movie 3 description most viewed", iconURL: nil),
            Movie(name: "movie 4 most viewed", description: "movie 4 description most viewed", iconURL: nil),
        ]
    }
    
    func getUpcoming() async throws -> [Movie] {
        return [
            
        ]
    }
    
}
