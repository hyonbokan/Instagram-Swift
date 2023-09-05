//
//  FirestoreManager.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/29.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    public func posts(for username: String, completion: @escaping (Result<[Post], Error>) -> Void) {
        let ref = database.collection("users")
            .document(username)
            .collection("posts")
        ref.getDocuments { snapshot, error in
            guard let posts = snapshot?.documents.compactMap({ Post(with: $0.data())
            }),
            error == nil else {
                return
            }
            
            completion(.success(posts))
        }
        
    }
    
    // Below uses Decodable Extension in "Resources/Extension"
    public func findUser(with email: String, completion: @escaping (User?) -> Void) {
        let ref = database.collection("users")
        ref.getDocuments { snapshot, error in
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }),
                error == nil
            else {
                completion(nil)
                return
            }
            
            let user = users.first(where: { $0.email == email })
            completion(user)
        }
    }
    
    public func createPost(newPost: Post, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            completion(false)
            return
        }
        let reference = database.document("users/\(username)/post/\(newPost.id)")
        guard let data = newPost.asDictionary() else {
            completion(false)
            return
        }
        // store data(username: example, email: exmaple) in the Firestore database document
        reference.setData(data) { error in
            completion(error == nil)
        }
    }
    
    
    public func createUser(newUser: User, completion: @escaping (Bool) -> Void) {
        let reference = database.document("users/\(newUser.username)")
        guard let data = newUser.asDictionary() else {
            completion(false)
            return
        }
        // store data(username: example, email: exmaple) in the Firestore database document
        reference.setData(data) { error in
            completion(error == nil)
        }
    }
}
