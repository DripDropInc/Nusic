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
var artistArray = [[Article]]()
var finalArray = [Article]()
var numberOfArticlesPerArtist = [Int]()

//MARK: Artist Request



func requestArtistID(Input input : String, complete: @escaping ((String?,Int?,String?) -> Void) ) {
    
    
    
    let sessionConfig = URLSessionConfiguration.default
    
    /* Create session, and optionally set a URLSessionDelegate. */
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    
    /* Create the Request:
     Request (GET https://music-api.musikki.com/v1/artists/100052041/news)
     */
    
    guard var URL = URL(string: "https://music-api.musikki.com/v1/artists/") else {return}
    let URLParams = ["q": (input),]
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
                    
                    followArray.append(newArtist)
                    
                    print("Artist Name: \(String(describing: artistName))")
                    print("Artist ID: \(String(describing: artistId))")
                    
                    complete(artistName, artistId, artistPhoto)
                } else {
                    complete(nil,nil,nil)
                    print("Sorry no artist found")
                }
            }
            else {
                // Failure
                complete(nil,nil,nil)
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        }})
    
    task.resume()
    session.finishTasksAndInvalidate()
}

// MARK: News Request
func requestArtistNews(input Input : Int, complete: @escaping (() -> Void)) {
    
    finalArray.removeAll()
    articlesArray.removeAll()
    
    
    let sessionConfig = URLSessionConfiguration.default
    
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    
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
                    
                    
                    
                    
                    
                    
                    let newArticle = Article()
                    newArticle.articleTitle = title.string
                    newArticle.articleSummary = summary.string
                    newArticle.articleURL = url.string
                    newArticle.articleImage = image.string
                    newArticle.articleSourceTitle = sourceTitle.string
                    newArticle.articleDate = newArticle.date(Day: day.intValue, Month: month.intValue, Year: year.intValue)
                    newArticle.articleLanguage = language.string
                    newArticle.articleArtistID = Input
                    
                    if newArticle.articleLanguage!.contains("en") {
                        
                        articlesArray.insert(newArticle, at: 0)
                        articlesArray.sort(by: { $0.articleDate?.compare($1.articleDate!) == .orderedDescending })
                    }
                }
                
                artistArray.insert(articlesArray, at: 0)
                for articles in artistArray {
                    numberOfArticlesPerArtist.append(articles.count)
                }
                let sortedArray = numberOfArticlesPerArtist.sorted(by: {(a, b) -> Bool in
                    return a > b
                })
                let myMax = sortedArray.first ?? 0
                if myMax != 0 {
                    for index in 0...myMax-1 {
                        for artist in artistArray {
                            if index >= artist.count {}
                            else {
                                let currentArtist = artist[index]
                                finalArray.append(currentArtist)
                            }
                        }
                    }
                    complete()
                }
            } else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        }
    })
    task.resume()
    session.finishTasksAndInvalidate()
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


