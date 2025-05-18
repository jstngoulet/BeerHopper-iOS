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

/// View model that manages the state and logic for displaying and searching forum posts.
/// Handles debounced search input and pagination control.
final class ForumPageViewModel: ObservableObject {
    
    enum ForumPageState {
        case pending
        case loading
        case loaded([ForumPost])
        case noResults
        case error(Error)
    }
    
    @Published
    var currentState: ForumPageState = .pending
    
    private(set) var isLoadingMore: Bool = false
    
    private var hasMorePages: Bool = true
    
    private var searchQuery: String?
    
    @Published
    var searchText: String = "" {
        didSet {
            searchText.isEmpty
            ? performDebouncedSearch(query: nil)
            : performDebouncedSearch(query: searchText)
        }
    }
    
    var debounceTask: Task<Void, Never>?
    
    /// the current page data for the query
    private var currentPageData: PageInfo?
    
    init() {
        Task { @MainActor [weak self] in
            await self?.getForumPosts(shouldResetPage: true)
        }
    }
    
    /// Debounces the execution of a search or fetch based on the user's query.
    /// - Parameter query: The optional search string. If `nil`, retrieves all posts. If not `nil`, performs a search query.
    private func performDebouncedSearch(query: String?) {
        debounceTask?.cancel()
        
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 1_000_000 * 2)
            
            //  If there is a query, run the search
            //  If not, just get the forum posts
            guard let searchQuery = query else {
                await self?.getForumPosts()
                return
            }
            
            await self?.search(txt: searchQuery)
        }
    }
    
    /// Executes a search request for forum posts matching the given text.
    /// Updates the view model state with the search results or an error.
    /// - Parameter txt: The optional search query string.
    @MainActor
    private func search(txt: String?) async {
        currentState = .loading
        isLoadingMore = true
        self.searchQuery = txt
        
        defer { isLoadingMore = false }
        
        do {
            let result = try await SearchAPI.performGeneralSearch(
                with: txt,
                types: [.posts]
            )
            
            if let posts = result.posts?.data,
               !posts.isEmpty {
                currentState = .loaded(posts)
            } else {
                currentState = .noResults
            }
            
        } catch {
            currentState = .error(error)
        }
    }
    
    /// Fetches a paginated list of forum posts from the API.
    /// - Parameter shouldResetPage: A Boolean indicating whether the current page info should be reset (e.g., on refresh).
    /// If true, starts from the first page.
    @MainActor
    func getForumPosts(shouldResetPage: Bool = false) async {
        // Skip if search is active
        guard searchQuery?.isEmpty ?? true else { return }
        
        // Skip if there are no more pages
        guard hasMorePages else { return }
        
        // Track current posts
        var currentPosts: [ForumPost] = []
        if case let .loaded(posts) = currentState {
            currentPosts = posts
        }
        
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        if shouldResetPage {
            currentPageData = nil
            currentState = .loading
            currentPosts = []
        }
        
        let nextPage = shouldResetPage ? 0 : (currentPageData?.page ?? 0) + 1
        let limit = currentPageData?.limit ?? 10
        
        do {
            let result = try await ForumAPI.getForumPosts(page: nextPage, limit: limit)
            
            currentPageData = result.pageInfo
            hasMorePages = result.pageInfo.totalPages > result.pageInfo.page
            
            if result.data.isEmpty && currentPosts.isEmpty {
                currentState = .noResults
            } else {
                currentState = .loaded(currentPosts + result.data)
            }
        } catch {
            currentState = .error(error)
        }
    }
    
    @MainActor
    func update(post: ForumPost) {
        //  Only continue if posts are loaded
        guard case .loaded(var posts) = currentState
        else { return }
        if let idx = posts.firstIndex(where: { $0.id == post.id }) {
            posts[idx] = post
            currentState = .loaded(posts)
        }
    }
}

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
