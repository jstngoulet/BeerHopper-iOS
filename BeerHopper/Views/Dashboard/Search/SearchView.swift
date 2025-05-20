//
//  SearchView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import SwiftUI
import Models
import NetworkingAPI

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    {
        didSet {
            debounceSearch(query: searchText)
        }
    }
    
    @Published
    var state: SearchState = .pending
    
    enum SearchState {
        case pending
        case loading
        case loaded([SearchResult.SearchListItem])
        case error(String)
    }
    
    private var debounceTask: Task<Void, Never>?
    
    private func debounceSearch(query: String) {
        debounceTask?.cancel()
        
        debounceTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(500))
            
            guard let searchText = self?.searchText,
                  searchText.trimmingCharacters(
                    in: .whitespacesAndNewlines
                  ).isEmpty == false
            else {
                self?.state = .pending
                return
            }
            
            await self?.search(txt: searchText)
        }
    }
    
    private func search(txt: String) async {
        
        //  Set to loading
        state = .loading
        
        //  Set current task
        do {
            let results = try await SearchAPI.performGeneralSearch(
                with: searchText
            )
            state = .loaded(results.searchItems)
        } catch {
            state = .error(error.localizedDescription)
        }
        
    }
}

public extension SearchResult {
    typealias SearchListItem = (
        url: String,
        title: String,
        description: String,
        id: String,
        type: CellType,
        placeholder: Image
    )
    
    enum CellType: String, CaseIterable {
        case hop, grain, yeast, post
    }
    
    var searchItems: [SearchListItem] {
        var items: [SearchListItem] = []
        
        //  Hops
        items += hops?.data.compactMap({ hop in
            (
                url: hop.imageUrl?.appending("?item=\(hop.id)") ?? "",
                title: hop.name,
                description: hop.notes,
                id: hop.id,
                type: .hop,
                placeholder: Image("DefaultHopIcon")
            )
        }) ?? []
        
        //  Grains
        items += grains?.data.compactMap({ grain in
            (
                url: grain.imageUrl?.appending("?item=\(grain.id)") ?? "",
                title: grain.name,
                description: grain.notes,
                id: grain.id,
                type: .grain,
                placeholder: Image("DefaultGrainIcon")
            )
        }) ?? []
        
        //  Yeasts
        items += yeasts?.data.compactMap({ yeast in
            (
                url: yeast.imageUrl?.appending("?item=\(yeast.id)") ?? "",
                title: yeast.name,
                description: yeast.notes,
                id: yeast.id,
                type: .yeast,
                placeholder: Image("DefaultYeastIcon")
            )
        }) ?? []
        
        items += posts?.data.compactMap({ post in
            (
                url: "",
                title: post.title,
                description: post.content,
                id: post.id,
                type: .post,
                placeholder: Image("DefaultForumPostIcon")
            )
        }) ?? []
        
        return items
    }
}

struct SearchView: View {
    
    @StateObject
    var viewModel = SearchViewModel()
    
    @State
    private var navigationPath = NavigationPath()
    
    enum SearchResultRoute: Hashable {
        case grain(id: String)
        case hop(id: String)
        case yeast(id: String)
        case post(id: String)
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                switch viewModel.state {
                case .pending:
                    Text("Pending Search")
                case .loading:
                    ProgressView("Loading...")
                case .loaded(let searchResults):
                    List(searchResults, id: \.id) { item in
                        Button(action: {
                            switch item.type {
                            case .grain:
                                navigationPath.append(SearchResultRoute.grain(id: item.id))
                            case .yeast:
                                navigationPath.append(SearchResultRoute.yeast(id: item.id))
                            case .hop:
                                navigationPath.append(SearchResultRoute.hop(id: item.id))
                            case .post:
                                navigationPath.append(SearchResultRoute.post(id: item.id))
                            }
                        }) {
                            SearchCard(
                                viewModel: SearchCardViewModel(
                                    iconURL: item.url,
                                    titleText: item.title,
                                    descriptionText: item.description,
                                    placeholderImage: item.placeholder
                                )
                            )
                        }
                    }
                    .listStyle(.plain)
                    
                case .error(let error):
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                }
            }
            .navigationDestination(for: SearchResultRoute.self) { route in
                switch route {
                case .grain(let id):
                    GrainDetailView(
                        with: id
                    ) { next in
                            navigationPath.append(
                                SearchResultRoute.grain(id: next.id)
                            )
                        }
                case .hop(let id):
                    EmptyView()
                case .yeast(let yeast):
                    EmptyView()
                case .post(let id):
                    ForumCardDetail(with: id)
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    SearchView()
}
