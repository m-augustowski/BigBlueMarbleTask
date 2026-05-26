//
//  MovieCardView.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation
import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let isFocused: Bool
    
    var body: some View {
        VStack {
            AsyncImage(url: movie.iconURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 300, height: 260)

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 260)
                        .clipped()

                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .frame(width: 300, height: 260)

                @unknown default:
                    EmptyView()
                }
            }
            
            VStack {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(movie.overview)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            .frame(alignment: .leading)
            .padding()
        }
        .background(Color(.systemGray))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .scaleEffect(isFocused ? 1.08 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

