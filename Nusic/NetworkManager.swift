//
//  RequestController.swift
//  Nusic
//
//  Created by AlexRapier on 2017-04-19.
//  Copyright © 2017 none. All rights reserved.
//

import Foundation
import SwiftyJSON
import MBProgressHUD



final class NetworkManager {
    
    private init() {}
    
    static let sharedInstance = NetworkManager()
    
    var articlesToDisplay = [Article]()
    var numberOfArticlesPerArtist = [Int]()
    
    
    //MARK: Artist Request
    
    var artists: [Artist] = []
    
    func followedArists() -> [Artist] {
        
        return artists.filter{ $0.follow == true }
        
    }
    
    
    
    func requestArtist(with userInput : String, complete: @escaping ((Artist?) -> Void) ) {
        
        
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Request (GET https://music-api.musikki.com/v1/artists/100052041/news)
         */
        
        guard var URL = URL(string: "https://music-api.musikki.com/v1/artists/") else {return}
        let URLParams = ["q": (userInput),]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        
        request.addValue("12a985889510737104d84141c9f79232", forHTTPHeaderField: "Appid")
        request.addValue("ae1bc12c9434b2bd3cf9e15242f08be8", forHTTPHeaderField: "Appkey")
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                if let data = data {
                    let json = JSON(data: data)
                    let result = json["results"].arrayValue
                    if result.count > 0 {
                        
                        let artist = result[0].dictionaryValue
                        let artistName = artist["name"]!.stringValue
                        let artistId = artist["mkid"]!.intValue
                        let artistPhoto = artist["image"]!.stringValue
                        
                        
                        
                        let newArtist = Artist()
                        newArtist.artistID = artistId
                        newArtist.artistName = artistName
                        newArtist.artistImage = artistPhoto
                        
                        self.artists.append(newArtist)
                        
                        print("Artist Name: \(String(describing: artistName))")
                        print("Artist ID: \(String(describing: artistId))")
                        
                        complete(newArtist)
                    } else {
                        complete(nil)
                        print("Sorry no artist found")
                    }
                }
                else {
                    // Failure
                    complete(nil)
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            }})
        
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // MARK: News Request
    func requestArtistNews(with artist: Artist, complete: @escaping (() -> Void)) {
        
        // make sure if the artist already has data that we don't do another fetch
        
        articlesToDisplay.removeAll()
        //        articlesArray.removeAll()
        
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let artistID = artist.artistID, let URL = URL(string: "https://music-api.musikki.com/v1/artists/\(artistID)/news") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        
        request.addValue("12a985889510737104d84141c9f79232", forHTTPHeaderField: "Appid")
        request.addValue("ae1bc12c9434b2bd3cf9e15242f08be8", forHTTPHeaderField: "Appkey")
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard error == nil else {
                print("URL Session Task Failed: %@", error!.localizedDescription);
                return
            }
            
            // Success
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("URL Session Task Succeeded: HTTP \(statusCode)")
            
            // Check if data is returned'
            guard let data = data else {
                return
            }
            
            let json = JSON(data: data)
            let results = json["results"].arrayValue
            for item in results {
                guard item["language"] == "en" else {
                    continue
                }
                
                let title = item["title"]
                let summary = item["summary"]
                let url = item["url"]
                let image = item["image"]
                let source = item["source"]
                let sourceTitle = source["title"]
                let publishDate = item["publish_date"]
                let year = publishDate["year"]
                let month = publishDate["month"]
                let day = publishDate["day"]
                
                let newArticle = Article()
                newArticle.articleTitle = title.string
                newArticle.articleSummary = summary.string
                newArticle.articleURL = url.string
                newArticle.articleImage = image.string
                newArticle.articleSourceTitle = sourceTitle.string
                newArticle.articleDate = newArticle.date(Day: day.intValue, Month: month.intValue, Year: year.intValue)
                //                        newArticle.articleArtistID = artistID
                
                artist.articles.append(newArticle)
                
                newArticle.artist = artist // don't worry it's weak!
                
            }
            
            self.mashup()
            complete()
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    //func sortedData(input : Array)
    
    func mashup() {
        
        guard artists.count > 0 else {
            print(#line, "the artist array is empty")
            return
        }
        
        // sort each artist array by date
        
        for artist in artists {
            numberOfArticlesPerArtist.append(artist.articles.count)
        }
        
        guard numberOfArticlesPerArtist.count > 0 else {
            return
        }
        
        let max: Int! = numberOfArticlesPerArtist.sorted(by: >).last
        
        print(#line, numberOfArticlesPerArtist)
        print(#line, max)
        
        
        for index in 0...max-1 {
            for artist in artists {
                if index >= artist.articles.count {}
                else {
                    let currentArtist = artist.articles[index]
                    articlesToDisplay.append(currentArtist)
                }
            }
        }
        
        
        
    }
    
    
    // MARK: Bio Request
    func requestArtistBio(input : Int, complete: @escaping ((String) -> Void)) {
        
        
        let sessionConfig = URLSessionConfiguration.default
        
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "https://music-api.musikki.com/v1/artists/\(input)/bio") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue("12a985889510737104d84141c9f79232", forHTTPHeaderField: "Appid")
        request.addValue("ae1bc12c9434b2bd3cf9e15242f08be8", forHTTPHeaderField: "Appkey")
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print(#line, "URL Session Task Succeeded: HTTP \(statusCode)")
                
                // Check if data is returned
                if let data = data {
                    let json = JSON(data: data)
                    print(#line, json)
                    let bioURL = json["article_url"].stringValue
                    
                    //print(#line, bioURL)
                    
                    complete(bioURL)
                    
                }
                else {
                    // Failure
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }  }
        })
        
        task.resume()
        session.finishTasksAndInvalidate()
        
    }
    
}



