//
//  ForumCardDetailViewModel.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/18/25.
//
import SwiftUI


@MainActor
final class ForumCardDetailViewModel: ObservableObject {
        
    @Published
    var post: ForumPost
    
    @Published
    var isReacting: Bool = false
    
    var onUpdate: ((ForumPost) -> Void)? = nil
    
    init(
        post: ForumPost,
        onUpdate: ((ForumPost) -> Void)? = nil
    ) {
        self.post = post
        self.onUpdate = onUpdate
    }
    
    func toggleLike() {
        Task {
            //  If already liked, remove,
            //  If no action, just add like
            //  If dislike, change to like
            if post.userReaction == .like {
                await changeReaction(nil)
            } else if post.userReaction == nil
                        || post.userReaction == .dislike {
                await changeReaction(.like)
            }
        }
    }
    
    func toggleDislike() {
        Task {
            //  If already disliked, remove.
            //  If no action, dislike
            //  if like, dislike
            if post.userReaction == .dislike {
                await changeReaction(nil)
            } else if post.userReaction == nil
                        || post.userReaction == .like {
                await changeReaction(.dislike)
            }
        }
    }
    
    func changeReaction(_ reaction: UserPostReaction?) async {
        
        //  Do not react if a request is in progress
        if isReacting { return }
        
        //  Reset
        defer { isReacting = false }
        
        do {
            self.isReacting = true
            self.post = try await ForumAPI.reactToPost(
                withId: post.id,
                reaction: reaction
            )
            self.onUpdate?(self.post)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func send(comment: String) async {
        
        defer { isReacting = false }
        
        do {
            self.isReacting = true
            _ = try await ForumAPI.commentOnPost(
                withId: post.id,
                comment: comment
            )
            self.post = try await ForumAPI.getPost(byId: post.id)
            self.onUpdate?(self.post)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
