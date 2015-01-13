//
//  Tracks.swift
//  Hola
//
//  Created by Atul Acharya on 1/9/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//


import Foundation
class Track {
    
    var title: String
    var price: String
    var previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    class func tracksWithJSON(allResults: NSArray) -> [Track] {
        var tracks = [Track]()
        
        if allResults.count > 0 {
            for trackInfo in allResults {
                // create a track
                if let kind = trackInfo["kind"] as? String {
                    if kind == "song" {
                        var trackPrice = trackInfo["trackPrice"] as? String
                        var trackName = trackInfo["trackName"] as? String
                        var trackPreviewUrl = trackInfo["previewUrl"] as? String
                        
                        if trackName == nil {
                            trackName = "Unknown"
                        }
                        else if trackPrice == nil {
                            trackPrice = "??"
                            println("unknown track price")
                        }
                        else if trackPreviewUrl ==  nil {
                            trackPreviewUrl = "?"
                        }
                        var track = Track(title: trackName!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                        tracks.append(track)
                    }
                }
            }
        }
        return tracks
    } // end func
}