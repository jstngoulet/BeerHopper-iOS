//
//  DashboardTabView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI
import NetworkingAPI

struct DashboardTabView: View {
    
    @State
    private var selectedTab: Int = 0
    
    @State
    private var isAuthenticated: Bool
    
    init(tabNumber: Int) {
        self._selectedTab = State(initialValue: tabNumber)
        self.isAuthenticated = RESTClient.isLoggedIn
        login()
    }
    
    init() {
        self._selectedTab = State(initialValue: 0)
        self.isAuthenticated = RESTClient.isLoggedIn
        login()
    }
    
    private func login() {
        
        //  Login here for now
        Task {
            guard let loginResult = try? await AuthAPI.login(
                email: "brewer.bob@brewmail.com",
                password: "BrewerBob22"
            ) else { return }
            self.isAuthenticated = loginResult.success
        }
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
            
            if isAuthenticated {
                FeedView().tabItem {
                    Label("Feed", systemImage: "person.crop.circle")
                }.tag(4)
            } else {
                LoginView(isLoggedIn: $isAuthenticated)
                    .tabItem {
                        Label("Login", systemImage: "person.crop.circle")
                    }.tag(4)
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
