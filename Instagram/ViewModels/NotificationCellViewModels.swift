//
//  NotificationCellViewModels.swift
//  Instagram
//
//  Created by dnlab on 2023/09/08.
//

import Foundation

struct LikeNotificationCellViewModel {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
}

struct FollowNotificationCellViewModel {
    let username: String
    let profilePictureUrl: URL
    let isCurrentUserFollowing: Bool
}

struct CommentNotificationCellViewModel {
    let username: String
    let profilePictureUrl: URL
    let postUrl: URL
}
