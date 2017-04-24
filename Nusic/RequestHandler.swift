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

var articlesArray = [Article]()
var sortedArticlesArray = [Article]()

//MARK: Artist Request

    func requestArtistID(input Input : String, complete: @escaping ((String,Int,String) -> Void) ) {
        
        
        
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Request (GET https://music-api.musikki.com/v1/artists/100052041/news)
         */
        
        guard var URL = URL(string: "https://music-api.musikki.com/v1/artists/") else {return}
        let URLParams = ["q": (Input),]
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
                
                    
                    print("Artist Name: \(String(describing: artistName))")
                    print("Artist ID: \(String(describing: artistId))")
                    
                    complete(artistName, artistId, artistPhoto)
                    } else {
                        print("Sorry no artist found")
                    }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
            }})
        
        task.resume()
        session.finishTasksAndInvalidate()
    }

// MARK: News Request
func requestArtistNews(input Input : Int, complete: @escaping (() -> Void)) {
    
    
    let sessionConfig = URLSessionConfiguration.default
    
    /* Create session, and optionally set a URLSessionDelegate. */
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    
    /* Create the Request:
     Request (GET https://music-api.musikki.com/v1/artists/100052041/news)
     */
    
    guard let URL = URL(string: "https://music-api.musikki.com/v1/artists/\(Input)/news") else {return}
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
            
            // Check if data is returned
            if let data = data {
                let json = JSON(data: data)
                let result = json["results"].arrayValue
                for currentIndex in result {
                    let title = currentIndex["title"]
                    let summary = currentIndex["summary"]
                    let url = currentIndex["url"]
                    let image = currentIndex["image"]
                    let source = currentIndex["source"]
                    let sourceTitle = source["title"]
                    let publishDate = currentIndex["publish_date"]
                    let year = publishDate["year"]
                    let month = publishDate["month"]
                    let day = publishDate["day"]
                    let language = currentIndex["language"]
                
                    
                    print("\(day) of \(month) \(year) is when this was published")
                    print(title)
                    print(summary)
                    print(url)
                    print(image)
                    print(sourceTitle)
                    print("---------------------------------------------------------------------------------------------")
                
                    let newArticle = Article()
                    newArticle.articleTitle = title.string
                    newArticle.articleSummary = summary.string
                    newArticle.articleURL = url.string
                    newArticle.articleImage = image.string
                    newArticle.articleSourceTitle = sourceTitle.string
                   newArticle.articleDate = newArticle.date(Day: day.intValue, Month: month.intValue, Year: year.intValue)
                    newArticle.articleLanguage = language.string
                    if newArticle.articleLanguage!.contains("en") {
                    
                                        articlesArray.insert(newArticle, at: 0)
                    articlesArray.sort(by: { $0.articleDate?.compare($1.articleDate!) == .orderedDescending })

                }
                complete()
            }
        }
        else {
            // Failure
            print("URL Session Task Failed: %@", error!.localizedDescription);
            }  }
    })
    
    task.resume()
    session.finishTasksAndInvalidate()
    
}



