//
//  DashboardTabView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI

struct DashboardTabView: View {
    
    @State
    private var selectedTab: Int = 0
    
    init(tabNumber: Int) {
        self._selectedTab = State(initialValue: tabNumber)
    }
    
    init() {
        self._selectedTab = State(initialValue: 0)
    }
    
    var body: some View {
        /**
         
         Pages Created (for unauth):
         • Search
         • Feed (Breweries, Beers, Checkins)
         • Forums
         • Ingredients / Recipes
         • Auth
         
         Pages Pending (for Auth)
         • Search
         • Feed (Breweries, Beers, Checkins)
         • Forums
         • Ingreidents / Recipes
         • Brew Day
         
         Items to Consider:
         • Tools
         • Profile
         
         */
        TabView(selection: $selectedTab) {
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }.tag(0)
            
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "list.dash.header.rectangle")
                }.tag(1)
            
            ForumView()
                .tabItem {
                    Label("Forum", systemImage: "signpost.right.and.left")
                }.tag(2)
            
            RecipesPageView()
                .tabItem {
                    Label("Recipes", systemImage: "stove")
                }.tag(3)
            
            LoginView()
                .tabItem {
                    Label("Login", systemImage: "person.crop.circle")
                }.tag(4)
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
