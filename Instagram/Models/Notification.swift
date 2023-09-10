//
//  Notification.swift
//  Instagram
//
//  Created by Michael Kan on 2023/09/09.
//

import Foundation

struct IGNotification: Codable {
    let identifier: String
    let notificationType: Int // 1: like, 2: comment, 3: follow
    let profilePictureUrl: String
    let username: String
    let dateString: String
    // Follow/Unfollow
    let isFollowing: Bool?
    // Like/Comment
    let postId: String?
    let postUrl: String?
}
