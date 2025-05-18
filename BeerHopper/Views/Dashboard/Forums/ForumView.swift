//
//  ForumView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/17/25.
//


import SwiftUI

final class ForumPageViewModel: ObservableObject {
    
    enum ForumPageState {
        case pending
        case loading
        case loaded([ForumPost])
        case error(Error)
    }
    
    @Published
    var currentState: ForumPageState = .pending
    
    @Published
    var searchText: String = "" {
        didSet {
            searchText.isEmpty
                ? performDebouncedSearch(query: nil)
                : performDebouncedSearch(query: searchText)
        }
    }
    
    var debounceTask: Task<Void, Never>?
    
    @State
    private(set) var navigationPath: NavigationPath = NavigationPath()
    
    /// the current page data for the query
    private var currentPageData: PageInfo?
    
    init() {
        Task { @MainActor [weak self] in
            await self?.getForumPosts(shouldResetPage: true)
        }
    }
    
    /// Function to perform the search when the search value changes
    /// - Parameter query: <#query description#>
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
    
    private func search(txt: String?) async {
        currentState = .loading
        
        do {
            let result = try await SearchAPI.performGeneralSearch(
                with: txt,
                types: [.posts]
            )
            
            currentState = .loaded(result.posts?.data ?? [])
        } catch {
            currentState = .error(error)
        }
    }
    
    func getForumPosts(shouldResetPage: Bool = false) async {
        currentState = .loading
        
        //  If reset, clear the page data
        if shouldResetPage {
            currentPageData = nil
        }
        
        do {
            let result = try await ForumAPI.getForumPosts(
                page: currentPageData?.page ?? 0,       //  Default to first page
                limit: currentPageData?.limit ?? 10,    //  Default to current limit
            )
            
            currentPageData = result.pageInfo
            currentState = .loaded(result.data)
        } catch {
            currentState = .error(error)
        }
    }
    
    func selectItem(post: ForumPost) {
        navigationPath.append(<#T##value: Hashable##Hashable#>)
    }
    
}

struct ForumView: View {
    
    @StateObject
    private var viewModel: ForumPageViewModel = ForumPageViewModel()
    
    var body: some View {
        NavigationView() {
            switch viewModel.currentState {
            case .pending:
                ZeroStateView(
                    viewModel: ZeroStateViewModel(
                        image: Image("search"),
                        title: "Search the Forum!",
                        buttons: nil
                    )
                )
            case .loading:
                Text("Loading")
            case .loaded(let posts):
                if posts.isEmpty {
                    ZeroStateView(
                        viewModel: ZeroStateViewModel(
                            image: nil,
                            title: "No Results Found",
                            buttons: [
                                ButtonConfig(
                                    id: "refresh-posts",
                                    title: "No Posts Found",
                                    icon: Image("refresh"),
                                    action: {
                                        viewModel.searchText = ""
                                    }
                                )
                            ]
                        )
                    )
                } else {
                    List(posts, id: \.id) { item in
                        NavigationLink {
                            SearchCard(
                                viewModel: SearchCardViewModel(
                                    iconURL: nil,
                                    titleText: item.title,
                                    descriptionText: item.content,
                                    placeholderImage: Image(systemName: "person")
                                )
                            )
                        } label: {
                            SearchCard(
                                viewModel: SearchCardViewModel(
                                    iconURL: nil,
                                    titleText: item.title,
                                    descriptionText: item.content,
                                    placeholderImage: Image(systemName: "lock")
                                )
                            )
                        }

                    }.listStyle(PlainListStyle())
                        .navigationTitle("Forum Posts")
                        .navigationBarTitleDisplayMode(.inline)
                }
            case .error(let err):
                Text(err.localizedDescription)
            }
        }
        .searchable(text: $viewModel.searchText)
    }
    
}

#Preview {
    ForumView()
}

#Preview ("With Tab") {
    DashboardTabView(tabNumber: 2)
}
