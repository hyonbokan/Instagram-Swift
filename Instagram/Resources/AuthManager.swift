//
//  AuthManager.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//
import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    // MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void){
        /*
         - Check if username is available
         - Check if email is available
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                /*
                 - Create account
                 - Insert account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    // insert into database
                    DatabaseManager.shared.inserNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        } else {
                            // Failed to insert to database
                            completion(false)
                            return
                        }
                    }
                }
                
                
            } else {
                // either username or email does not exists
                completion(false)
            }
        }
    }
    // check @escaping and void of a closure
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void){
        if let email = email {
            Auth.auth().signIn(withEmail: email, password: password) {
                authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false) //Call the completion handler with a false value
                    return
                }
                completion(true) //Call the completion handler with a true value
            }
        } else if let username = username {
            print(username)
        }
    }
    /// Attempt to log out the user
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            print(error)
            completion(false)
            return
        }
    }
    
}
