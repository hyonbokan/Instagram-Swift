//
//  SettingsModels.swift
//  Instagram
//
//  Created by Michael Kan on 2023/09/28.
//

import Foundation
import UIKit

struct SettingsSection {
    let title: String
    let options: [SettingOption]
}

struct SettingOption {
    let title: String
    let image: UIImage?
    let color: UIColor
    let handler: (() -> Void)
}
