//
//  ForumCardCell.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/18/25.
//

import SwiftUI

struct ForumCardCell: View {
    
    @ObservedObject var viewModel: ForumCardDetailViewModel
    
    init(post: ForumPost) {
        self.viewModel = ForumCardDetailViewModel(
            post: post
        )
    }
    
    var body: some View {
        ForumCard(
            model: viewModel
        )
    }
    
}

#Preview {
    ForumCardCell(
        post: ForumPost(
            id: "44c5ed2e-2c10-4b65-9ac8-93ef1cf3a846",
            title: "Deficio civitas comburo arguo una tergeo suscipit.",
            content: "Itaque depraedor tertius victoria quam vespillo arca usque textilis. Coma uter vilitas. Tunc strenuus atrox molestiae auxilium adopto vulgaris ultio.\nComparo debeo acervus creo decerno paens denuncio. Coniecto velociter torqueo vox. Soleo pariatur demo deprecator careo amet.",
            dateCreated: Date(),
            createdBy: ForumUser(
                id: UUID().uuidString,
                username: "Test U."
            ),
            likes: 9,
            dislikes: 2,
            userReaction: .like,
            comments: nil
        )
    )
}
