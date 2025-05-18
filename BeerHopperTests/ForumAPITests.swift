//
//  ForumAPITests.swift
//  BeerHopper
//
//  Created by Justin Goulet on 5/15/25.
//
import XCTest
@testable import BeerHopper

final class ForumAPITests: BeerHopperTests {
    
    let testPostTitle: String       = "Test Title"
    let testPostContent: String     = "This is a test forum post created for unit testing."
    let testCommentContent: String  = "This is a test comment."
    let environment: RESTClient.Host = .development
    let email: String               = "TEST-35DCC913-1EF1-46EF-8FF5-C8C160479A3C-TEST@beerhopper.me"
    let password: String            = "BeerHopper123!"
    
    override func setUp() async throws {
        try await AuthAPI.login(
            email: email,
            password: password,
            env: environment
        )
    }
    
    /// Tests that the general forum post listing returns a successful response and contains data.
    func test_getForumPosts_returnsResults() async throws {
        let result = try await ForumAPI.getForumPosts(
            page: 1,
            limit: 5,
            env: environment
        )
        XCTAssertTrue(result.success)
        XCTAssertGreaterThanOrEqual(result.data.count, 0)
    }
    
    /// Tests that the popular forum post listing returns a successful response.
    func test_getPopularPosts_returnsResults() async throws {
        let result = try await ForumAPI.getPopularPosts(
            page: 1,
            limit: 5,
            env: environment
        )
        XCTAssertTrue(result.success)
    }
    
    /// Tests that a new forum post can be created successfully and its content is accurate.
    func test_createPost_success() async throws {
        let post = try await ForumAPI.createPost(
            withTitle: testPostTitle,
            content: testPostContent,
            env: environment
        )
        XCTAssertEqual(post.title, testPostTitle)
        XCTAssertEqual(post.content, testPostContent)
    }
    
    /// Tests that a created post can be retrieved by ID and matches the original post.
    func test_getPost_byId_success() async throws {
        let created = try await ForumAPI.createPost(
            withTitle: testPostTitle,
            content: testPostContent,
            env: environment
        )
        let fetched = try await ForumAPI.getPost(
            byId: created.id,
            env: environment
        )
        XCTAssertEqual(created.id, fetched.id)
    }
    
    /// Tests that a comment can be successfully added to a forum post.
    func test_commentOnPost_success() async throws {
        let newTitle = [
            testPostTitle
            , "with comment"
        ].joined(separator: "-")
        
        let post = try await ForumAPI.createPost(
            withTitle: newTitle,
            content: testPostContent,
            env: environment
        )
        let comment = try await ForumAPI.commentOnPost(
            withId: post.id,
            comment: testCommentContent,
            env: environment
        )
        XCTAssertEqual(comment.content, testCommentContent)
    }
    
    /// Tests that a user can react to a post with a 'like' and the post is updated.
    func test_reactToPost_like() async throws {
        let post = try await ForumAPI.createPost(
            withTitle: testPostTitle,
            content: testPostContent,
            env: environment
        )
        let updated = try await ForumAPI.reactToPost(
            withId: post.id,
            reaction: .like,
            env: environment
        )
        XCTAssertEqual(updated.id, post.id)
    }
    
}
