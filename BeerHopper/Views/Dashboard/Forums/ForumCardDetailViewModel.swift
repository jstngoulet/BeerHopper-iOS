//
//  ForumCardDetailViewModel.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/18/25.
//
import SwiftUI

/// View model responsible for managing the state and user interactions
/// for a single forum post, including reactions and comments.
@MainActor
final class ForumCardDetailViewModel: ObservableObject {
    
    /// Holds the current screen state, including the forum post data or an error/loading state.
    @Published
    var currentState: ScreenState<ForumPost> = .pending
    
    /// A flag indicating whether a like/dislike or comment action is in progress.
    @Published
    var isReacting: Bool = false
    
    /// Optional closure that gets triggered when the post is updated (e.g. reacted to or commented on).
    var onUpdate: ((ForumPost) -> Void)? = nil
    
    /// Initializes the view model with an already available `ForumPost`.
    /// - Parameters:
    ///   - post: The forum post to display.
    ///   - onUpdate: An optional closure to handle post updates.
    init(
        post: ForumPost,
        onUpdate: ((ForumPost) -> Void)? = nil
    ) {
        self.currentState = .loaded(post)
        self.onUpdate = onUpdate
    }
    
    /// Initializes the view model using a `postId` and fetches the post data.
    /// - Parameters:
    ///   - postId: The ID of the forum post to load.
    ///   - onUpdate: An optional closure to handle post updates.
    init(
        postId: String,
        onUpdate: ((ForumPost) -> Void)? = nil
    ) {
        self.onUpdate = onUpdate
        self.currentState = .loading
        
        Task {
            await getPost(withID: postId)
        }
    }
    
    /// Toggles the like status for the post.
    /// - If the post is already liked, the reaction is removed.
    /// - If the post is not reacted to or disliked, a like is added.
    func toggleLike() {
        Task {
            guard case let .loaded(post) = currentState
            else { return }
            
            if post.userReaction == .like {
                await changeReaction(nil)
            } else if post.userReaction == nil
                        || post.userReaction == .dislike {
                await changeReaction(.like)
            }
        }
    }
    
    /// Toggles the dislike status for the post.
    /// - If the post is already disliked, the reaction is removed.
    /// - If the post is not reacted to or liked, a dislike is added.
    func toggleDislike() {
        Task {
            guard case let .loaded(post) = currentState
            else { return }
            
            if post.userReaction == .dislike {
                await changeReaction(nil)
            } else if post.userReaction == nil
                        || post.userReaction == .like {
                await changeReaction(.dislike)
            }
        }
    }
    
    /// Sends a reaction update to the API and updates the local post state.
    /// - Parameter reaction: The new reaction to apply (.like, .dislike, or nil).
    func changeReaction(_ reaction: UserPostReaction?) async {
        if isReacting { return }
        
        guard case let .loaded(post) = currentState
        else { return }
        
        defer { isReacting = false }
        
        do {
            self.isReacting = true
            let post = try await ForumAPI.reactToPost(
                withId: post.id,
                reaction: reaction
            )
            self.currentState = .loaded(post)
            self.onUpdate?(post)
        } catch {
            currentState = .error(error)
        }
    }
    
    /// Sends a comment to the API and refreshes the post.
    /// - Parameter comment: The comment text to post.
    @MainActor
    func send(comment: String) async {
        defer { isReacting = false }
        
        guard case let .loaded(post) = currentState
        else { return }
        
        do {
            self.isReacting = true
            _ = try await ForumAPI.commentOnPost(
                withId: post.id,
                comment: comment
            )
            await getPost(withID: post.id)
        } catch {
            currentState = .error(error)
        }
    }
    
    /// Get the post from the ID given
    /// - Parameter postId: The id of the post we are searching for
    func getPost(withID postId: String) async {
        currentState = .loading
        
        do {
            let post = try await ForumAPI.getPost(byId: postId)
            
            await MainActor.run {
                currentState = .loaded(post)
                self.onUpdate?(post)
            }
        } catch {
            currentState = .error(error)
        }
    }
}
