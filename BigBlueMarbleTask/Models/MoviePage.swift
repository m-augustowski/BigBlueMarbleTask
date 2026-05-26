//
//  MoviePage.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import Foundation

struct MoviePage: Equatable {
    let movies: [Movie]
    let page: Int
    let totalPages: Int
    let totalResults: Int
    
    var hasMorePages: Bool {
        page < totalPages
    }
}
