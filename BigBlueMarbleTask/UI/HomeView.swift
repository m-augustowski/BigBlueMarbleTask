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
                state: $model.popularMoviesState,
                focusedMovieID: $focusedMovieID
            )
            .task {
                await model.loadPopularMovies()
            }
            
            MovieSectionView(
                category: .nowPlaying,
                state: $model.nowPlayingMoviesState,
                focusedMovieID: $focusedMovieID
            )
            .task {
                await model.loadNowPlayingMovies()
            }
            
            MovieSectionView(
                category: .upcoming,
                state: $model.upcomingMoviesState,
                focusedMovieID: $focusedMovieID
            )
            .task {
                await model.loadUpcomingMovies()
            }
        }
        .task {
            await model.prefetchGenres()
        }
    }
    
}
