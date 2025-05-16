//
//  HomeView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Home Screen")
                NavigationLink("Go to Details", destination: DetailView(title: "Home Detail"))
            }
            .navigationTitle("Home")
        }
    }
}
