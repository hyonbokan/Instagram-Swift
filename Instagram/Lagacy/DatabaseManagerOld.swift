////
////  DatabaseManager.swift
////  Instagram
////
////  Created by Michael Kan on 2023/08/15.
////
//import FirebaseDatabase
//public class DatabaseManager {
//    //A static constant property is a property that belongs to the type itself rather than to an instance of the type. This means that the value of a static constant is shared among all instances of the type and can be accessed using the type itself, without the need to create an instance.
//    // DatabaseManager.shared
//    static let shared = DatabaseManager()
//
//    private let database = Database.database().reference()
//
//    /// Check if username and email is available
//    /// - Parameters
//    ///     - email: String representing email
//    ///     - username: String representing username
//    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void){
//        completion(true)
//    }
//    /// Insert new user data to database
//    /// - Parameters
//    ///     - email: String representing email
//    ///     - username: String representing username
//    ///     - completion: Async callback for result if database entry succeeded
//    public func inserNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
//        // email address contains '.' resulting in an error
//        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in
//            if error == nil {
//                // succeeded
//                completion(true)
//                return
//            } else {
//                // failed
//                completion(false)
//                return
//            }
//        }
//    }
//
//}
