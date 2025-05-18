//
//  RecipesPageView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/17/25.
//

import SwiftUI

final class RecipesPageViewModel: ObservableObject {
    
    //  Accessor to the RESTClient model
    var isLoggedIn: Bool
    { RESTClient.isLoggedIn == false }
    
}

struct RecipesPageView: View {
    
    @StateObject
    private var viewModel: RecipesPageViewModel = RecipesPageViewModel()
    
    @State
    private var selectedIndex: Int = 0
    
    /**
     This view is going to have a section for ingredients
     in addition to created / global recipes.
     
     This page is going to have a top tab bar for switching between personal
     and public recipes. With a recipe, a user can see included
     ingredients and instructions, selecting an ingredient for further detail.
     */
    
    var body: some View {
        
        if viewModel.isLoggedIn {
            //  Add the top bar
            TopTabBarView(
                selected: $selectedIndex,
                tabs: [
                    TopTabBarView.TabBarItem(
                        title: "Public Recipes",
                        view: PublicRecipesPage(),
                        id: "public-recipes"
                    ),
                    TopTabBarView.TabBarItem(
                        title: "My Recipes",
                        view: MyRecipesPage(),
                        id: "my-recipes"
                    )
                ]
            )
        } else {
            //  Just add the primary page
            PublicRecipesPage()
        }
        
    }
}

struct PublicRecipesPage: View {
    var body: some View {
        Text("Public Recipes")
    }
}


struct MyRecipesPage: View {
    var body: some View {
        Text("My Recipes")
    }
}

#Preview {
    RecipesPageView()
}
