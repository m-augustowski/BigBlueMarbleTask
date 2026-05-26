//
//  SecretsProvider.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/26/26.
//

import Foundation

enum SecretsProvider {
    static var tmdbApiToken: String {
        guard let token = Bundle.main.object(
            forInfoDictionaryKey: "TMDB_API_TOKEN"
        ) as? String else {
            fatalError("Missing TMDB_API_TOKEN")
        }

        return token
    }
}
