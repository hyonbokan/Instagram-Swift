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
