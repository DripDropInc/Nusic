//
//  NewsRequest.swift
//  Nusic
//
//  Created by Trevor MacGregor on 2017-04-20.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class RequestController {
    func requestArtistID(input Input : String) {
        
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
                
                // Check if data is returned
                if let data = data {
                    let json = JSON(data: data)
                    let result = json["results"]

