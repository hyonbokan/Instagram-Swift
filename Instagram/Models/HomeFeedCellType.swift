//
//  HomeFeedCellType.swift
//  Instagram
//
//  Created by Michael Kan on 2023/09/01.
//

import Foundation

enum HomeFeedCellType {
    case poster(viewModel: PosterCollectionViewCellViewModel)
    case post(viewModel: PostCollectionViewCellViewModel)
    case actions(viewModel: PostActionsCollectionViewCellViewModel)
    case likeCount(viewModel: PostLikesCollectionViewCellViewModel)
    case caption(viewModel: PostCaptionCollectionViewCellViewModel)
    case timestamp(viewModel: PostDateTimeCollectionViewCellViewModel)
}
