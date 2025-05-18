//
//  ForumCardCell.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/18/25.
//

import SwiftUI

struct ForumCardDetail: View {
    
    @ObservedObject
    private var viewModel: ForumCardDetailViewModel
    
    @State
    private var commentText: String = ""
    
    init(
        post: ForumPost,
        onUpdate: ((ForumPost) -> Void)? = nil
    ) {
        self.viewModel = ForumCardDetailViewModel(
            post: post,
            onUpdate: onUpdate
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForumCard(model: viewModel)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    Divider()
                    
                    if let comments = viewModel.post.comments, !comments.isEmpty {
                        Text("Comments")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(comments, id: \.id) { item in
                                Text(item.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .padding(.horizontal)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer(minLength: 20)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
            
            HStack {
                TextField("Add a comment", text: $commentText)
                    .textFieldStyle(BaseTextFieldStyle())
                
                Button(action: {
                    Task { @MainActor in
                        await viewModel.send(comment: self.commentText)
                        self.commentText = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                }
                .buttonStyle(.automatic)
                .padding(8)
                .disabled(
                    self.commentText.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )
            }
            .padding()
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    ForumCardDetail(
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

struct ForumCard: View {
    
    @ObservedObject
    private var viewModel: ForumCardDetailViewModel
    
    init(model: ForumCardDetailViewModel) {
        self.viewModel = model
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 8) {
                ToggleButton(
                    isSelected: viewModel.post.userReaction == .like,
                    action: viewModel.toggleLike,
                    image: Image(systemName: "chevron.up")
                ).disabled(viewModel.isReacting)
                
                Text(String(viewModel.post.netLikes))
                
                ToggleButton(
                    isSelected: viewModel.post.userReaction == .dislike,
                    action: viewModel.toggleDislike,
                    image: Image(systemName: "chevron.down")
                ).disabled(viewModel.isReacting)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.post.dateCreated.formatted())
                    .font(Theme.Fonts.caption)
                
                Text(viewModel.post.title)
                    .font(Theme.Fonts.heading.bold())
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(viewModel.post.content)
                    .font(Theme.Fonts.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
