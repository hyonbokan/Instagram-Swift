//
//  StorageManager.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/29.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    public func uploadPost(
        data: Data?,
        id: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let username = UserDefaults.standard.string(forKey: "username"), let data = data else { return
            
        }
        storage.child("\(username)/post/\(id)profile_picture.png").putData(data, metadata: nil) {
            _, error in
            completion(error == nil)
        }
    }
    
    public func downloadURL(for post: Post, completion: @escaping (URL?) -> Void) {
        guard let ref = post.storageReference else {
            completion(nil)
            return
        }
        
        storage.child(ref).downloadURL { url, _ in
            completion(url)
        }
    }
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfilePicture(
        username: String,
        data: Data?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = data else { return
            
        }
        storage.child("\(username)/profile_picture.png").putData(data, metadata: nil) {
            _, error in
            completion(error == nil)
        }
    }
}
