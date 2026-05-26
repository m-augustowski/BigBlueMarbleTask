//
//  Movie.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation

struct Movie: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String
    let overview: String
    let iconURL: URL?
}
