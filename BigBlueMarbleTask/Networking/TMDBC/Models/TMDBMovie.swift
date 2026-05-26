//
//  TMDBMovie.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import Foundation

struct TMDBMovie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let genreIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
    }
}
