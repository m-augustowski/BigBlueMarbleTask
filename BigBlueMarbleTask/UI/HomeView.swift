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
    @State private var retriedCategory: MovieCategory?
    
    private let clientEndpoint: MovieClientEndpoint
    
    init(clientEndpoint: MovieClientEndpoint) {
        self.clientEndpoint = clientEndpoint
        _model = StateObject(
            wrappedValue: HomeViewModel(clientEndpoint: clientEndpoint)
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
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
                        retry(.popular)
                    }
                    .id(MovieCategory.popular)
                    
                    MovieSectionView(
                        category: .nowPlaying,
                        mode: .small,
                        state: $model.nowPlayingMoviesState,
                        focusedMovieID: $focusedMovieID
                    ) {
                        retry(.nowPlaying)
                    }
                    .id(MovieCategory.nowPlaying)
                    
                    MovieSectionView(
                        category: .upcoming,
                        mode: .large,
                        state: $model.upcomingMoviesState,
                        focusedMovieID: $focusedMovieID
                    ) {
                        retry(.upcoming)
                    }
                    .id(MovieCategory.upcoming)
                }
                .task {
                    await model.load()
                }
                .onChange(of: model.popularMoviesState) { _, state in
                    restoreRetriedSection(.popular, state: state, proxy: proxy)
                }
                .onChange(of: model.nowPlayingMoviesState) { _, state in
                    restoreRetriedSection(.nowPlaying, state: state, proxy: proxy)
                }
                .onChange(of: model.upcomingMoviesState) { _, state in
                    restoreRetriedSection(.upcoming, state: state, proxy: proxy)
                }
            }
            .navigationDestination(for: MovieCategory.self) { category in
                AllMoviesView(category: category, clientEndpoint: clientEndpoint)
            }
        }
    }
    
    private func retry(_ category: MovieCategory) {
        retriedCategory = category
        model.retryLoad(for: category)
    }
    
    private func restoreRetriedSection(_ category: MovieCategory, state: MovieSectionState, proxy: ScrollViewProxy) {
        guard retriedCategory == category else { return }
        
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                proxy.scrollTo(category, anchor: .center)
            }
        }
        
        if state != .loading {
            retriedCategory = nil
        }
    }
    
}
