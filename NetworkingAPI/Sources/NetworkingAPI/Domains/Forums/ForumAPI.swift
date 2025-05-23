//
//  ForumAPI.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

import Foundation
import Models

/// A service class responsible for interacting with the BeerHopper Forum API.
/// Provides methods to fetch, create, and interact with forum posts and comments.
public
final class ForumAPI: NSObject {
    
    /// Fetches a paginated list of all forum posts.
    /// - Parameters:
    ///   - page: Optional page number for pagination.
    ///   - limit: Optional limit for number of posts per page.
    ///   - env: API environment to target (default is the current environment).
    /// - Returns: A `ForumPostResponse` containing post data and pagination info.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    @discardableResult
    public
    class func getForumPosts(
        page: Int? = nil,
        limit: Int? = nil,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> ForumPostResponse {
        do {
            guard let responseData = try await RESTClient.perform(
                GetAllPostsRequest(
                    page: page,
                    limit: limit
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
                        
            let result = try RESTClient.sharedDecoder.decode(
                ForumPostResponse.self,
                from: responseData
            )
            
            return result
            
        } catch {
            throw error
        }
    }
    
    /// Fetches a paginated list of popular forum posts.
    /// - Parameters:
    ///   - page: Optional page number for pagination.
    ///   - limit: Optional limit for number of posts per page.
    ///   - env: API environment to target (default is the current environment).
    /// - Returns: A `ForumPostResponse` with popular posts and pagination info.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    @discardableResult
    public
    class func getPopularPosts(
        page: Int? = nil,
        limit: Int? = nil,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> ForumPostResponse {
        do {
            guard let responseData = try await RESTClient.perform(
                GetPopularPostsRequest(
                    page: page,
                    limit: limit
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let result = try RESTClient.sharedDecoder.decode(
                ForumPostResponse.self,
                from: responseData
            )
            
            return result
            
        } catch {
            throw error
        }
    }
    
    /// Retrieves a specific forum post by its unique identifier.
    /// - Parameters:
    ///   - postId: The ID of the forum post to fetch.
    ///   - env: API environment to target (default is the current environment).
    /// - Returns: A `ForumPost` object.
    /// - Throws: An error if the request fails or decoding fails.
    @discardableResult
    public
    class func getPost(
        byId postId: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> ForumPost {
        do {
            guard let dataResponse = try await RESTClient.perform(
                GetPostByIDRequest(
                    postID: postId
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let result = try RESTClient.sharedDecoder.decode(
                ForumPost.self,
                from: dataResponse
            )
            
            return result
        } catch {
            throw error
        }
    }
    
    /// Creates a new forum post with the given title and content.
    /// - Parameters:
    ///   - title: The title of the post.
    ///   - content: The body content of the post.
    ///   - env: API environment to target (default is the current environment).
    /// - Returns: A newly created `ForumPost`.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    @discardableResult
    public
    class func createPost(
        withTitle title: String,
        content: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> ForumPost {
        do {
            guard let responseData = try await RESTClient.perform(
                CreatePostRequest(
                    title: title,
                    content: content
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let result = try RESTClient.sharedDecoder.decode(
                ForumPost.self,
                from: responseData
            )
            
            return result
            
        } catch {
            throw error
        }
    }
    
    /// Submits a user reaction (like or dislike) to a specific forum post.
    /// - Parameters:
    ///   - postId: The ID of the post to react to.
    ///   - reaction: The type of reaction to submit (like or dislike).
    ///   - env: API environment to target (default is the current environment).
    /// - Returns: The updated `ForumPost` if the request succeeds, or `nil`.
    /// - Throws: An error if the request fails.
    @discardableResult
    public
    class func reactToPost(
        withId postId: String,
        reaction: UserPostReaction? = nil,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> ForumPost {
        
        do {
            //  Do nothing with the response as it is not used
            guard let responseData = try await RESTClient.perform(
                ReactToPostRequest(
                    postId: postId,
                    reaction: reaction
                ),
                env: env
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            //  If successful, fetch the post
            let result = try RESTClient.sharedDecoder.decode(
                ForumPost.self,
                from: responseData
            )
            
            return result
        } catch {
            throw error
        }
    }
    
    /// Adds a comment to a forum post.
    /// - Parameters:
    ///   - postId: The ID of the post to comment on.
    ///   - comment: The content of the comment to post.
    ///   - env: API environment to target (default is the current environment).
    /// - Returns: A new `ForumComment` object representing the submitted comment.
    /// - Throws: An error if the request fails.
    @discardableResult
    public
    class func commentOnPost(
        withId postId: String,
        comment: String,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> ForumComment {
        do {
            guard let dataResponse = try await RESTClient.perform(
                CommentOnPostRequest(
                    postId: postId,
                    comment: comment
                )
            ) else { throw RESTClient.RESTError.noDataReturned }
            
            let result = try RESTClient.sharedDecoder.decode(
                ForumComment.self,
                from: dataResponse
            )
            
            return result
        } catch {
            throw error
        }
    }
    
}
