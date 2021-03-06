//
//  ResponseParser.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/6/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import Foundation

final class ResponseParser {
    func parse(JSON: [String: Any]) -> SearchResponse? {
        guard let container = JSON["photos"] as? [String: Any],
            let totalString = container["total"] as? String,
            let total = Int(totalString),
            let photosJSON = container["photo"] as? [[String: Any]],
            let photos = _getPhotos(photosJSON: photosJSON) else {
                return nil
        }
        
        var searchResponse = SearchResponse()
        searchResponse.totalCount = total
        searchResponse.photots = photos
        
        return searchResponse
    }
}

// MARK: - Private Helper Method
fileprivate extension ResponseParser {
    func _getPhotos(photosJSON: [[String: Any]]) -> [Photo]? {
        var photos = [Photo]()
        
        for photoJSON in photosJSON {
            if let id = photoJSON["id"] as? String,
                let farm = photoJSON["farm"] as? Int,
                let server = photoJSON["server"] as? String,
                let secret = photoJSON["secret"] as? String,
                let title = photoJSON["title"] as? String {
                photos.append(Photo(id: id, farm: farm, server: server, secret: secret, title: title))
            }
        }
        
        return photos.count == 0 ? nil : photos
    }
}
