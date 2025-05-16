//
//  DashboardTabView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI

struct DashboardTabView: View {
    var body: some View {
        TabView {
            LoginView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}




struct DetailView: View {
    let title: String
    
    var body: some View {
        Text("Detail for \(title)")
            .navigationTitle(title)
    }
}

#Preview {
    DashboardTabView()
}
