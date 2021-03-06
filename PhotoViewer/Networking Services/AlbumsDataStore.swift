
//
//  AlbumsDataStore.swift
//  PhotoViewer
//
//  Created by Jhantelle Belleza on 8/8/17.
//  Copyright © 2017 JhantelleB. All rights reserved.
//

import Foundation
import SDWebImage

class AlbumsDataStore {
    
    public func getAlbumsFromAPIClient(completion: @escaping ([Album], Error?) -> Void) {
        APIClient.getAlbumsFromAPI(from: Constants.defaultURL) { (albumDataResult) in
            switch albumDataResult {
            case .Success(let photos):
                completion(self.convertKeysToArray(albums: self.parse(photos)), nil)
            case .Failure(let error):
                completion([], error)
            }
        }
    }
    
    func parse(_ items: [[String:Any]]) -> [Int:[Photo]] {
        var albums: [Int:[Photo]] = [:]
        
        for item in items {
            guard let albumId = item["albumId"] as? Int else { return [:] }
            guard let id = item["id"] as? Int else { return [:] }
            guard let title = item["title"] as? String else { return [:] }
            guard let url = item["url"] as? String else { return [:] }
            guard let thumbnailUrl = item["thumbnailUrl"] as? String else { return [:] }
            
            let photo = Photo(id: id, title: title)
            photo.photoImageUrl = url
            photo.thumbnailImageUrl = thumbnailUrl
            
            if albums[albumId] != nil {
                albums[albumId]?.append(photo)
            } else {
                albums[albumId] = [photo]
            }
        }
        return albums
    }
    
    func convertKeysToArray(albums: [Int:[Photo]]) -> [Album] {
        let keys = Array(albums.keys)
        let sortedKeys = keys.sorted()
        var albumArray: [Album] = []
        
        for key in sortedKeys {
            guard let photos = albums[key] else { return [] }
            var album = Album(albumId: key)
            album.photos = photos
            albumArray.append(album)
        }
        return albumArray
    }
}
