
//
//  Article.swift
//  Nusic
//
//
//  Created by Trevor MacGregor on 2017-04-20.
//  Copyright © 2017 Nusic_Inc. All rights reserved.
//


import UIKit

class Article {
    
    var articleTitle: String?
    var articleSummary: String?
    var articleURL: String?
    var articleImage: String?
    var articleSourceTitle: String?
    var articleDate : Date?
    var articleLanguage: String?
//    var articleArtistID: Int?
    
    weak var artist: Artist? // loop ma I'm weak!
    
func date(Day day : Int, Month month : Int, Year year : Int) -> Date {
    
    let dateString = "\(year)-\(month)-\(day)"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let date = dateFormatter.date(from: dateString)
    
    return date!
    
    
}
}
