//
//  TMDBResponse.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import Foundation

struct TMDBMoviesResponse: Codable {
    let results: [TMDBMovie]
}
