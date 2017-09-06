//
//  Photo.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/6/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import Foundation

struct SearchResponse {
    var totalCount = 0
    var photots = [Photo]()
}

struct Photo {
    let id: String
    let farm: Int
    let server: String
    let secret: String
    let title: String
    
    var imageURL: URL? {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
    }
}
