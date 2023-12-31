//
//  AnalyticsManager.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/28.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    enum FeedInteraction: String {
        case like
        case comment
        case share
        case reported
        case doubleTapToLike
    }
    
    func logFeedInteraction(_ type: FeedInteraction) {
        Analytics.logEvent(
            "feedback_interaction", parameters: [
                "type": type.rawValue.lowercased()
            ]
        )
    }
}
