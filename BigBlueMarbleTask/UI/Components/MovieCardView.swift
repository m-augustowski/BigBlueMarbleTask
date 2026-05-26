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
        VStack(spacing: 0.0) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: movie.iconURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 400, height: 360)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 400, height: 360)
                            .clipped()

                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 400, height: 360)

                    @unknown default:
                        EmptyView()
                    }
                }

                if isFocused {
                    Button {

                    } label: {
                        Image(systemName: "play.fill")
                            .font(.title3)
                            .foregroundStyle(.black)
                            .padding(14)
                            .background(.white)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(16)
                    .transition(
                         .asymmetric(
                             insertion: .scale(scale: 0.7)
                                 .combined(with: .opacity),
                             removal: .opacity
                         )
                     )
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(movie.title)
                        .font(.caption)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                }
                
                HStack {
                    Text(movie.genres.prefix(2).joined(separator: " • "))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .scaleEffect(isFocused ? 1.10 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

