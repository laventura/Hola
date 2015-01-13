//
//  Album.swift
//  Hola
//
//  Created by Atul Acharya on 1/8/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import Foundation

class Album {
    
    var title:              String
    var price:              String
    var thumbnailImageURL:  String
    var largeImageURL:      String
    var itemURL:            String
    var artistURL:          String
    var collectionId:       Int

    init(name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int ) {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
    
    // Fetch Album info from iTunes URL
    class func albumsWithJSON(allResults: NSArray) -> [Album] {
        // Create an empty array of Albums to append to from this list
        var albums = [Album]()
        
        if allResults.count > 0 {
            
            // Sometimes, iTunes returns a Collection, not a track name, so check for that
            for result in allResults {
                
                var name = result["trackName"] as? String
                if name == nil {
                    name = result["collectionName"] as? String
                }
                
                // sometimes price is formattedPrice or collectionPrice; sometimes as float or a string. 
                var price = result["formattedPrice"] as? String
                if price == nil {
                    price = result["collectionPrice"] as? String
                    if price == nil {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$"+nf.stringFromNumber(priceFloat!)!
                            
                        }
                    }
                }
                
                let thumbnailURL    = result["artworkUrl60"] as? String ?? ""
                let imageURL        = result["artworkUrl100"] as? String ?? ""
                let artistURL       = result["artistViewUrl"] as? String ?? ""
                var collectionId    = result["collectionId"] as? Int
                
                var itemURL =   result["collectionViewUrl"] as? String
                if itemURL == nil {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                var newAlbum = Album(name: name!, price: price!, thumbnailImageURL: thumbnailURL, largeImageURL: imageURL, itemURL: itemURL!, artistURL: artistURL, collectionId: collectionId!)
                albums.append(newAlbum)
            }
        }
        return albums
    } // func
    
}
