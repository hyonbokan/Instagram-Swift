//
//  StorageManager.swift
//  Instagram
//
//  Created by Michael Kan on 2023/08/15.
//

import FirebaseStorage

public class StorageManagerOld {
    
    static let shared = StorageManagerOld()
    
    private let bucket = Storage.storage().reference()
    //adding custom error
    public enum IGStorageManagerError: Error {
        case failedToDownload
    }
    
    
    // What is result <URL, Error>?
    public func uploadUserPost(model: UserPost, completion: @escaping (Result<URL, Error>) -> Void) {
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void){
        bucket.child(reference).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(.failedToDownload))
                return
            }
            
            completion(.success(url))
        })
    }
    
}
