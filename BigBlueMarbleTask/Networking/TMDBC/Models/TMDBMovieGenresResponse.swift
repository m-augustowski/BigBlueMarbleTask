//
//  TMDBMovieGenresResponse.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import Foundation

struct TMDBMovieGenresResponse: Codable {
    let genres: [TMDBMovieGenre]
}
