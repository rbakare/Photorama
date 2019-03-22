//
//  PhotoStore.swift
//  Photorama
//
//  Created by Raheem Bakare on 2019-03-14.
//  Copyright © 2019 centennial college. All rights reserved.
//

import Foundation
import UIKit

enum ImageResult{
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error{
    case imageCreationError
    
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    
    func fetchInterestingPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = FlickrApi.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation{
                completion(result)
            }
            if let jsonData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    print(jsonObject)
                } catch let error {
                    print("Error creating JSON object: \(error)")
                }
            } else if let requestError = error {
                print("Error fetching interesting photos: \(requestError)")
            } else {
                print("Unexpected error with the request")
            }
        }
        task.resume()
    }
    
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation{
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
                // Couldn't create an image
                if data == nil {
                    return .failure(error! )
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        return .success (image)
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrApi.photos(fromJSON: jsonData)
    }
}
