//
//  ForumPageViewModel.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

import SwiftUI

/// View model that manages the state and logic for displaying and searching forum posts.
/// Handles debounced search input and pagination control.
final class ForumPageViewModel: ObservableObject {
    
    /// The current UI state of the forum page, including loaded posts or error state.
    @Published
    var currentState: ScreenState<[ForumPost]> = .pending
    
    /// Indicates whether more data is currently being loaded (e.g., pagination).
    private(set) var isLoadingMore: Bool = false
    
    /// Tracks whether additional pages of forum posts are available.
    private var hasMorePages: Bool = true
    
    /// Stores the current search query, if any.
    private var searchQuery: String?
    
    /// The user's current search input. Triggers debounced search or fetch.
    @Published
    var searchText: String = "" {
        didSet {
            searchText.isEmpty
            ? performDebouncedSearch(query: nil)
            : performDebouncedSearch(query: searchText)
        }
    }
    
    /// Debounce task used to delay search requests while typing.
    var debounceTask: Task<Void, Never>?
    
    /// The current pagination metadata for the posts being displayed.
    private var currentPageData: PageInfo?
    
    /// Initializes the view model and immediately fetches the first page of forum posts.
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
    
    /// Updates a specific post in the currently loaded post list.
    /// - Parameter post: The post with updated data to be inserted into the list.
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
