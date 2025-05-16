//
//  ForumAPI.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//

import Foundation

/// A service class responsible for interacting with the BeerHopper Forum API.
/// Provides methods to fetch, create, and interact with forum posts and comments.
final class ForumAPI: NSObject {
    
    /// Fetches a paginated list of all forum posts.
    /// - Parameters:
    ///   - page: Optional page number for pagination.
    ///   - limit: Optional limit for number of posts per page.
    ///   - env: API environment to target (default is the current environment).
    /// - Returns: A `ForumPostResponse` containing post data and pagination info.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    @discardableResult
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
            
            print(String(bytes: responseData, encoding: .utf8))
            
            let result = try JSONDecoder().decode(
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
    class func getPopularPosts(
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
            
            let result = try JSONDecoder().decode(
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
            
            let result = try JSONDecoder().decode(
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
            
            let result = try JSONDecoder().decode(
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
    class func reactToPost(
        withId postId: String,
        reaction: UserPostReaction? = nil,
        env: RESTClient.Host = RESTClient.currentENV
    ) async throws -> ForumPost? {
        
        do {
            //  Do nothing with the response as it is not used
            try await RESTClient.perform(
                ReactToPostRequest(
                    postId: postId,
                    reaction: reaction
                ),
                env: env
            )
            
            //  If successful, fetch the post
            //  This can be removed after the API is updated.
            //  The API should reutrn the full post already
            return try await getPost(byId: postId)
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
            
            //  Return comment now, but this will be a different object later
            return ForumComment(
                id: UUID().uuidString,
                content: comment,
                dateCreated: Date().description,
                dateUpdated: Date().description,
                createdBy: ForumUser(id: UUID().uuidString, username: "You")
            )
        } catch {
            throw error
        }
    }
    
}
