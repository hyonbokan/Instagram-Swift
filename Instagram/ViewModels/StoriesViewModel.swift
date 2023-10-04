//
//  File.swift
//  Instagram
//
//  Created by dnlab on 2023/10/04.
//

import Foundation
import UIKit

struct StoriesViewModel {
    let stories: [Story]
}

struct Story {
    let username: String
    let image: UIImage?
}
