//
//  HomeView.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import Foundation
import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var model: HomeViewModel
    
    @FocusState private var focusedMovieID: Movie.ID?
    
    init(clientEndpoint: MovieClientEndpoint) {
        _model = StateObject(
            wrappedValue: HomeViewModel(clientEndpoint: clientEndpoint)
        )
    }
    
    var body: some View {
        ScrollView {
            Text("Home View")
                .font(.title)
                .frame(alignment: .leading)
            
            Divider()
            
            MovieSectionView(
                category: .popular,
                mode: .medium,
                state: $model.popularMoviesState,
                focusedMovieID: $focusedMovieID
            ) {
                model.retryLoad(for: .popular)
            }
            
            MovieSectionView(
                category: .nowPlaying,
                mode: .small,
                state: $model.nowPlayingMoviesState,
                focusedMovieID: $focusedMovieID
            ) {
                model.retryLoad(for: .nowPlaying)
            }
            
            MovieSectionView(
                category: .upcoming,
                mode: .large,
                state: $model.upcomingMoviesState,
                focusedMovieID: $focusedMovieID
            ) {
                model.retryLoad(for: .upcoming)
            }
        }
        .task {
            await model.load()
        }
    }
    
}
