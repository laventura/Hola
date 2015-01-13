//
//  APIController.swift
//  Hola
//
//  Created by Atul Acharya on 1/8/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import Foundation

// Tutorial: http://jamesonquave.com/blog/developing-ios-apps-using-swift-part-3-best-practices/ 

protocol APIControllerProtocol {
    func didReceiveAPIResults (results: NSDictionary)
}

class APIController {
    
    var delegate: APIControllerProtocol    //  will be set to SearchResultsViewController, which implements this protocol
    
    init(delegate: APIControllerProtocol) {
        self.delegate = delegate
        
    }
    
    func get (path: String) {
        
        let url: NSURL = NSURL(string: path)!
        let session = NSURLSession.sharedSession()
        
        println("...Trying NSURL: \(url.description)")
        
        let task = session.dataTaskWithURL(url, completionHandler:  { data, response, error -> Void in
            println("...network request completed")
            if error != nil {
                println("Error with network request: \(error.localizedDescription)")
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if err != nil {
                // error w/ JSON
                println("*** JSON error: \(err!.localizedDescription)")
            }
            
            let results: NSArray = jsonResult["results"] as NSArray
            self.delegate.didReceiveAPIResults(jsonResult)
            })
        task.resume()
    } // end func
    
    
    // -- NEW --
    func searchItunesFor(searchTerm: String) {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            
            // invoke the network request
            get(urlPath)            
        }
    } // end func
    
    func lookupAlbum(collectionId: Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
    
    
    // ------ OLD code below ----
    func OLDsearchItunesForOLD (searchTerm: String) {
        
        // iTunes wants multiple search terms separated by '+', so replace ' ' by '+'
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            // ***  OLD *** // let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            
            // Search for Music Albums
            // let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            println("--> urlPath: \(urlPath)")
            
            let url:NSURL = NSURL(string: urlPath)!
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if (error != nil) {
                    println(error.description)
                    println(error.localizedDescription)
                    
                }
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if (err != nil) {
                    // error parsing
                    println("Error parsing JSON: \(err!.description)")
                }
                let results: NSArray = jsonResult["results"] as NSArray
                
                // load the UI
                self.delegate.didReceiveAPIResults(jsonResult)
                
            })
            
            task.resume()
            
        } // end if
        
    } // end searchItunesFor()

    
    
}