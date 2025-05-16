//
//  ExploreView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Explore Screen")
                NavigationLink("View Item", destination: DetailView(title: "Explore Item"))
            }
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreView()
}
