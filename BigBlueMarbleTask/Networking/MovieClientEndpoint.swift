//
//  MovieClientEndpoint.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation
import SwiftUI

final class MovieClientEndpoint {
    
    let client: MovieClientProtocol
    
    init() {
        self.client = TMDBClient()
    }
    
}
