//
//  ContentView.swift
//  BigBlueMarbleTask
//
//  Created by Nicolas Augustowski on 5/25/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    private let clientEndpoint: MovieClientEndpoint = MovieClientEndpoint()

    var body: some View {
        HomeView(clientEndpoint: clientEndpoint)
    }

}


/*
 NavigationSplitView {
     List {
         ForEach(items) { item in
             NavigationLink {
                 Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
             } label: {
                 Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
             }
         }
         .onDelete(perform: deleteItems)
     }
     .toolbar {
         ToolbarItem {
             Button(action: addItem) {
                 Label("Add Item", systemImage: "plus")
             }
         }
     }
 } detail: {
     Text("Select an item")
 }
 */
