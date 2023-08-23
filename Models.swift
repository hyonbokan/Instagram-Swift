//
//  Models.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/20.
//

import Foundation

enum Gender {
    case male, female, other
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

struct User {
    let username: String
    let name: (first: String, last: String)
    let profilePhoto: URL
    let birthDate: Date
    let gender: Gender
    let counts: UserCount
    let joinDate: Date
}

public enum UserPostType {
    case photo, video
}

/// Structure of user posts
public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let postURL: URL // either video, url or full res photo
    let caption: String?
    let likeCount: [PostLike]
    let comment: [PostComment]
    let createdDate: Date
    let taggedUsers: [String]
}

struct PostLike {
    let username: String
    let postIndentifier: String
}

struct CommentLike {
    let username: String
    let commentIndentifier: String
}

struct PostComment {
    let indetifier: String
    let username: String
    let text: String
    let createded: Date
    let likes: [CommentLike]
}


