//
//  ContentView.swift
//  SwiftUISearchBar
//
//  Created by Zheng on 9/20/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var searchBar = SearchBarConfigurator()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, world!")
                Text("Search Text: \(searchBar.searchText)")
            }
            .navigationTitle("Search Bar")
            .add(searchBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
