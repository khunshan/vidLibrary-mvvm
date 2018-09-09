//
//  Movie.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation
import SwiftyJSON

//ViewWindow Model
struct Movie: JSONMapper {
    
    let skyGoUrl            :String?
    let url                 :String?
    let reviewAuthor        :String?
    let id                  :String?
    let cert                :String?
    let viewingWindow       :ViewingWindow?
    let headline            :String?
    let cardImages          :[WebImage]?
    let directors           :[Person]?
    let sum                 :String?
    let keyArtImages        :[WebImage]?
    let synopsis            :String?
    let body                :String?
    let cast                :[Person]?
    let skyGoId             :String?
    let year                :String?
    let duration            :Int?
    let rating              :Int?
    let class_              :String?
    let galleries           :[Galleries]?
    let videos              :[Video]?
    let genres              :[String]?
    let quote               :String?
    
    
    init(data: Any) {
        let json            = JSON(data)
        skyGoUrl            = json["skyGoUrl"].string
        url                 = json["url"].string
        reviewAuthor        = json["reviewAuthor"].string
        id                  = json["id"].string
        cert                = json["cert"].string
        viewingWindow       = ViewingWindow(data: json["viewingWindow"])
        headline            = json["headline"].string
        sum                 = json["sum"].string
        synopsis            = json["synopsis"].string
        body                = json["body"].string
        skyGoId             = json["skyGoId"].string
        year                = json["year"].string
        duration            = json["duration"].int
        rating              = json["rating"].int
        class_              = json["class"].string
        genres              = json["genres"].arrayObject as? [String]
        quote               = json["quote"].string
        
        if let arrayData = JSON(json["cardImages"]).to(type: WebImage.self) { //Array of Object
            cardImages = arrayData as? [WebImage] } else { cardImages = [] }
        
        if let arrayData = JSON(json["directors"]).to(type: Person.self) { //Array of Object
            directors       = arrayData as? [Person] } else { directors = [] }
        
        if let arrayData = JSON(json["keyArtImages"]).to(type: WebImage.self) { //Array of Object
            keyArtImages    = arrayData as? [WebImage] } else { keyArtImages = [] }
        
        if let arrayData = JSON(json["directors"]).to(type: Person.self) { //Array of Object
            cast            = arrayData as? [Person] } else { cast = [] }
        
        if let arrayData = JSON(json["galleries"]).to(type: Galleries.self) { //Array of Object
            galleries       = arrayData as? [Galleries] } else { galleries = [] }
        
        if let arrayData = JSON(json["videos"]).to(type: Video.self) { //Array of Object
            videos       = arrayData as? [Video] } else { videos = [] }
    }
    

}






