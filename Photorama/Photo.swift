//
//  Photo.swift
//  Photorama
//
//  Created by Raheem Bakare on 2019-03-14.
//  Copyright © 2019 centennial college. All rights reserved.
//

import Foundation

import Foundation

class Photo: Equatable {
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        // Two Photos are the same if they have the same photolD
        return lhs.photoID == rhs.photoID
    }
}


/*
 extension Photo: Equatable {
 static func == (lhs: Photo, rhs: Photo) -> Bool {
 // Two Photos are the same if they have the same photolD
 return lhs.photoID == rhs.photolD
 }
 }*/
