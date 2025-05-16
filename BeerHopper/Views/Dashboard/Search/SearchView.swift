//
//  SearchView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    {
        didSet {
            debounceSearch(query: searchText)
        }
    }
    
    @Published var state: SearchState = .pending
    
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

extension SearchResult {
    typealias SearchListItem = (url: String, title: String, description: String, id: String, type: CellType)
    
    enum CellType {
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
                type: .hop
            )
        }) ?? []
        
        //  Grains
        items += grains?.data.compactMap({ grain in
            (
                url: grain.imageUrl?.appending("?item=\(grain.id)") ?? "",
                title: grain.name,
                description: grain.notes,
                id: grain.id,
                type: .grain
            )
        }) ?? []
        
        //  Yeasts
        items += yeasts?.data.compactMap({ yeast in
            (
                url: yeast.imageUrl?.appending("?item=\(yeast.id)") ?? "",
                title: yeast.name,
                description: yeast.name,
                id: yeast.id,
                type: .yeast
            )
        }) ?? []
        
        return items
    }
}

struct SearchView: View {
    
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationSplitView {
            switch viewModel.state {
            case .pending:
                Text("Pending Search")
            case .loading:
                Text("Loading")
            case .loaded(let searchResults):
                List(searchResults, id: \.id) { item in
                    NavigationLink {
                        SearchCard(
                            viewModel: SearchCardViewModel(
                                iconURL: item.url,
                                titleText: item.title,
                                descriptionText: item.description
                            )
                        )
                    } label: {
                        SearchCard(
                            viewModel: SearchCardViewModel(
                                iconURL: item.url,
                                titleText: item.title,
                                descriptionText: item.description
                            )
                        )
                    }
                }.listStyle(.plain)
            case .error(let error):
                Text(error)
            }
        } detail: {
            Text("Detail")
        }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)

    }
}

#Preview {
    SearchView()
}
