//
//  GrainDetailView.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/19/25.
//

import SwiftUI
import DesignSystem
import Models
import NetworkingAPI

/// ViewModel responsible for fetching and managing the state of a specific grain's data.
final class GrainDetailViewModel: ObservableObject {
    
    /// Represents the current screen state (loading, loaded, error, etc.) for a grain.
    @Published
    var state: ScreenState<Grain> = .pending
    
    /// Initializes the view model and fetches a grain by its ID.
    /// - Parameter grainId: The ID of the grain to load.
    init(grainId: String) {
        fetchGrain(withId: grainId)
    }
    
    /// Initializes the view model with a pre-loaded grain.
    /// - Parameter grain: A grain object to display without fetching from the API.
    init(with grain: Grain) {
        state = .loaded(grain)
    }
    
    /// Fetches the grain data from the API and updates the screen state accordingly.
    /// - Parameter id: The ID of the grain to fetch.
    private func fetchGrain(withId id: String) {
        
        self.state = .loading
        
        Task {
            do {
                let grain = try await IngredientsAPI.fetchGrain(withID: id)
                
                await MainActor.run {
                    state = .loaded(grain)
                }
                
            } catch {
                await MainActor.run {
                    state = .error(error)
                }
            }
        }
    }
    
}

/// A SwiftUI view that displays the detail view for a specific grain.
/// Handles different states (loading, error, loaded) using the view model.
struct GrainDetailView: View {
    
    @ObservedObject
    private var viewModel: GrainDetailViewModel
    
    private var grainSelected: ((Grain) -> Void)?
    
    /// Initializes the view by loading a grain via its ID.
    /// - Parameters:
    ///   - grainId: The grain ID to fetch and display.
    ///   - onGrainSelection: Optional callback triggered when a grain is selected.
    init(
        with grainId: String
        , onGrainSelection: (@MainActor (Grain) -> Void)? = nil
    ) {
        self.viewModel = GrainDetailViewModel(
            grainId: grainId
        )
        self.grainSelected = onGrainSelection
    }
    
    /// Initializes the view with a pre-loaded grain.
    /// - Parameters:
    ///   - grain: The grain object to show.
    ///   - onGrainSelection: Optional callback triggered when a grain is selected.
    init(
        with grain: Grain
        , onGrainSelection: (@MainActor (Grain) -> Void)? = nil
    ) {
        self.viewModel = GrainDetailViewModel(
            with: grain
        )
        self.grainSelected = onGrainSelection
    }
    
    /// View content that conditionally renders based on loading state.
    var body: some View {
        switch viewModel.state {
        case .pending, .loading:
            ProgressView()
        case .loaded(let grain):
            ScrollView {
                GrainView(
                    grain: grain,
                    onGrainSelection: self.grainSelected
                )
            }
        case .error(let err):
            ZeroStateView(
                viewModel: ZeroStateViewModel(
                    image: Image("DefaultGrainIcon"),
                    title: err.localizedDescription,
                    buttons: nil
                )
            )
        case .noResults:
            ZeroStateView(
                viewModel: ZeroStateViewModel(
                    image: Image("DefaultGrainIcon"),
                    title: "Grain could not be found",
                    buttons: nil
                )
            )
        }
    }
}

/// A subview responsible for displaying a single grain's detailed information,
/// including image, name, notes, flavor descriptors, beer styles, and substitutes.
struct GrainView: View {
    
    @State
    private var grain: Grain
    
    private var grainSelected: ((Grain) -> Void)?
    
    /// Initializes the view with a grain and optional selection callback.
    /// - Parameters:
    ///   - grain: The grain to render.
    ///   - onGrainSelection: Optional callback when a substitute grain is tapped.
    init(
        grain: Grain
        , onGrainSelection: (@MainActor (Grain) -> Void)? = nil
    ) {
        self.grain = grain
        self.grainSelected = onGrainSelection
    }
    
    /// The main UI layout showing grain image, notes, descriptors, styles, and substitutes.
    var body: some View {
        
        VStack(alignment: .center, spacing: 8) {
            
            AsyncImageView(
                url: grain.imageUrl ?? "",
                placeholder: Image("DefaultGrainIcon")
            )
            .aspectRatio(contentMode: .fit)
            .frame(width: 128, height: 128)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(grain.name)
                .font(Theme.Fonts.heading.bold())
                .padding(.vertical, 8)
            
            Text(grain.notes)
                .font(Theme.Fonts.body)
                .multilineTextAlignment(.center)
            
            //  Table with properties
            BasicTableView(
                viewModel: BasicTableViewViewModel(
                    tableRows: [
                        ["Attribute", "Value"],
                        ["Origin", grain.origin],
                        ["Type", grain.type],
                        ["Lovibond (Color)", grain.lovibond.description],
                        ["Potential SG", grain.potentialSG.description],
                        ["Usage", grain.usage]
                    ]
                )
            ).padding(.vertical, 8)
            
            //  Flavor
            if !grain.flavorDescriptors.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text("Flavor Descriptors")
                        .font(Theme.Fonts.subheading.bold())
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 8)
                    
                    WrappingChipStack(
                        configs: grain.flavorDescriptors.map({ descriptor in
                            ButtonConfig(
                                id: UUID().uuidString,
                                title: descriptor.capitalized,
                                action: {}
                            )
                        })
                    )
                }.padding(.vertical)
            }
            
            //  Beer Styles
            if !grain.commonBeerStyles.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text("Beer Styles")
                        .font(Theme.Fonts.subheading.bold())
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 8)
                    
                    WrappingChipStack(
                        configs: grain.commonBeerStyles.map({ style in
                            ButtonConfig(
                                id: UUID().uuidString,
                                title: style.capitalized,
                                action: {}
                            )
                        })
                    )
                }.padding(.bottom)
            }
            
            //Subs
            if let subs = grain.substitutes, !subs.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    
                    Text("Similar Grains")
                        .font(Theme.Fonts.subheading.bold())
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 8)
                    
                    WrappingChipStack(
                        configs: subs.map({ sub in
                            ButtonConfig(
                                id: UUID().uuidString,
                                title: sub.name.capitalized,
                                action: { grainSelected?(sub) }
                            )
                        })
                    )
                }.padding(.bottom)
            }
            
            Spacer()
        }.padding()
    }
    
}


#Preview {
    NavigationStack {
        GrainDetailView(
            with: "0028237b-e11c-4129-8e56-91b7007405f9"
        )
    }
}
