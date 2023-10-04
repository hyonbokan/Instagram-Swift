//
//  HapticsManager.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/28.
//

import Foundation
import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
