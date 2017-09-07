//
//  PhotoFavoritesStore.swift
//  Autolist Exercise
//
//  Created by RICHARD TACKETT on 9/6/17.
//  Copyright © 2017 RICHARD TACKETT. All rights reserved.
//

import Foundation
import CoreData

final class PhotoFavoritesStore {
    fileprivate let managedContext = CoreDataStack.shared.managedContext
    fileprivate let favoritesFetch: NSFetchRequest<Favorite> = Favorite.fetchRequest()
    
    func isFavorite(photoID: String) -> Bool {
        favoritesFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Favorite.photoID), photoID)
        
        do {
            let results = try managedContext.fetch(favoritesFetch)
            if results.count > 0 {
                return true
            } else {
                return false
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
            return false
        }
    }
    
    func saveAsFavorite(photoID: String) {
        favoritesFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Favorite.photoID), photoID)
        
        do {
            let results = try managedContext.fetch(favoritesFetch)
            if results.count > 0 {
                if let favorite = results.first {
                    managedContext.delete(favorite)
                }
                
            } else {
                let favorite = Favorite(context: managedContext)
                favorite.photoID = photoID
            }
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}
