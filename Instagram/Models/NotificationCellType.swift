//
//  NotificationCellType.swift
//  Instagram
//
//  Created by dnlab on 2023/09/08.
//

import Foundation

enum NotificationCellType {
    case follow(viewModel: FollowNotificationCellViewModel)
    case like(viewModel: LikeNotificationCellViewModel)
    case comment(viewModel: CommentNotificationCellViewModel)
}
