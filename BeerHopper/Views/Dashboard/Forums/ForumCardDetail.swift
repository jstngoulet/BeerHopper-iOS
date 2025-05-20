//
//  ForumCardCell.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/18/25.
//

import SwiftUI
import DesignSystem
import Models

/// A detailed view for displaying a single forum post along with its comments and an input field to add new comments.
struct ForumCardDetail: View {
    
    @ObservedObject
    private var viewModel: ForumCardDetailViewModel
    
    /// Stores the text input for a new comment.
    @State
    private var commentText: String = ""
    
    /// Initializes the detail view using a `ForumPost` instance.
    /// - Parameters:
    ///   - post: The forum post to display.
    ///   - onUpdate: Optional closure to handle updates to the post.
    init(
        post: ForumPost,
        onUpdate: ((ForumPost) -> Void)? = nil
    ) {
        self.viewModel = ForumCardDetailViewModel(
            post: post,
            onUpdate: onUpdate
        )
    }
    
    /// Initializes the detail view using a post ID.
    /// - Parameters:
    ///   - postId: The ID of the forum post to fetch and display.
    ///   - onUpdate: Optional closure to handle updates to the post.
    init(
        with postId: String,
        onUpdate: ((ForumPost) -> Void)? = nil
    ) {
        self.viewModel = ForumCardDetailViewModel(
            postId: postId,
            onUpdate: onUpdate
        )
    }
    
    /// The body of the view, which includes the forum post, comments, and comment input.
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
                    
                    if case let .loaded(post) = viewModel.currentState,
                       let comments = post.comments,
                       !comments.isEmpty {
                        
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

/// A subview for rendering the main content of a forum post, including like/dislike controls and post metadata.
struct ForumCard: View {
    
    @ObservedObject
    private var viewModel: ForumCardDetailViewModel
    
    /// Creates a ForumCard view with the provided view model.
    /// - Parameter model: The detail view model used to populate the view.
    init(model: ForumCardDetailViewModel) {
        self.viewModel = model
    }
    
    /// The body of the ForumCard, showing vote toggles and post metadata and content.
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if case let .loaded(post) = viewModel.currentState {
                VStack(spacing: 8) {
                    ToggleButton(
                        isSelected: post.userReaction == .like,
                        action: viewModel.toggleLike,
                        image: Image(systemName: "chevron.up")
                    ).disabled(viewModel.isReacting)
                    
                    Text(String(post.netLikes))
                    
                    ToggleButton(
                        isSelected: post.userReaction == .dislike,
                        action: viewModel.toggleDislike,
                        image: Image(systemName: "chevron.down")
                    ).disabled(viewModel.isReacting)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(post.dateCreated.formatted())
                        .font(Theme.Fonts.caption)
                    
                    Text(post.title)
                        .font(Theme.Fonts.heading.bold())
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(post.content)
                        .font(Theme.Fonts.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
