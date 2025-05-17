//
//  SearchCard.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/14/25.
//

import SwiftUI

class SearchCardViewModel: ObservableObject {
    @Published var iconURL: String?
    @Published var titleText: String?
    @Published var descriptionText: String?
    @Published var placeholder: Image?
    
    init(
        iconURL: String? = nil,
        titleText: String? = nil,
        descriptionText: String? = nil,
        placeholderImage: Image? = nil
    ) {
        self.iconURL = iconURL
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.placeholder = placeholderImage
    }
}

struct SearchCard: View {
    
    @StateObject var viewModel: SearchCardViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImageView(
                url: viewModel.iconURL ?? "",
                placeholder: viewModel.placeholder
                    ?? Image(systemName: "photo")
            )
            .frame(width: 48, height: 48)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                if let title = viewModel.titleText {
                    Text(title)
                        .font(.headline)
                }
                
                if let description = viewModel.descriptionText {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer() // Pushes content to fill full width
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(10)
    }
}

#Preview {
    SearchCard(
        viewModel: SearchCardViewModel(
            iconURL: "https://picsum.photos/200",
            titleText: "Beer",
            descriptionText: "Lorem ipsum dolor sit amet"
        )
    )
}
