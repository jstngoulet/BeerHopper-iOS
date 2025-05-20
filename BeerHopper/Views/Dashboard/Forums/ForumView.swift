//  ForumView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/17/25.
//
//  Description:
//  This file defines the ForumView, which displays a list of forum posts within a navigable UI.
//  It supports debounced search functionality and loading states for both general browsing and search queries.
//  The view model handles data fetching from the server, pagination tracking, and search execution with proper UI updates.
//
//  Components:
//  - ForumPageViewModel: Handles state, search, and API calls.
//  - ForumView: Root view that responds to different loading states and renders post content.
//  - ForumPostRow: Renders individual post cells using SearchCard.
//
//  Features:
//  - Debounced search
//  - Search result and pagination support
//  - Inline navigation titles and loading/zero states
import SwiftUI


/// Main view for browsing and searching forum posts.
/// Responds to loading, error, and content states from the view model.
struct ForumView: View {
    
    @StateObject
    private var viewModel: ForumPageViewModel = ForumPageViewModel()
    
    /// The main view rendering logic based on the current forum state.
    /// Shows different UI views for pending, loading, loaded, no results, or error states.
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.currentState {
                case .pending:
                    ZeroStateView(
                        viewModel: ZeroStateViewModel(
                            image: Image(systemName: "arrow.clockwise"),
                            title: "Search the Forum!",
                            buttons: nil
                        )
                    )
                case .noResults:
                    ZeroStateView(
                        viewModel: ZeroStateViewModel(
                            image: nil,
                            title: "No Results Found",
                            buttons: [
                                ButtonConfig(
                                    id: "refresh-posts",
                                    title: "No Posts Found",
                                    icon: Image(systemName: "arrow.clockwise"),
                                    action: {
                                        viewModel.searchText = ""
                                    }
                                )
                            ]
                        )
                    )
                case .loading:
                    Text("Loading")
                case .loaded(let posts):
                    List(Array(posts.enumerated()), id: \.offset) { (idx, post) in
                        
                        NavigationLink {
                            ForumCardDetail(
                                post: post,
                                onUpdate: { updated in
                                    Task { @MainActor  in
                                        viewModel.update(post: updated)
                                    }
                                }
                            )
                        } label: {
                            ForumCardCell(post: post)
                                .onAppear {
                                    if post.id == posts.last?.id
                                        && !viewModel.isLoadingMore {
                                        Task {
                                            await viewModel.getForumPosts()
                                        }
                                    }
                                }
                        }
                        
                    }.listStyle(PlainListStyle())
                    
                        .searchable(text: $viewModel.searchText)
                        .refreshable {
                            await viewModel.getForumPosts(shouldResetPage: true)
                        }
                        .navigationTitle("Forum Posts")
                        .navigationBarTitleDisplayMode(.inline)
                case .error(let err):
                    Text(err.localizedDescription)
                }
            }
        }
    }
    
}

#Preview {
    ForumView()
}

#Preview ("With Tab") {
    DashboardTabView(tabNumber: 2)
}
