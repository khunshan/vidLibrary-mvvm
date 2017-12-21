//
//  Gallaries.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation
import SwiftyJSON

//Galleries Model
struct Galleries: JSONMapper {
    
    let title           : String?
    let url             : String?
    let thumbnailUrl    : String?
    let id              : String?

    init(data: Any) {
        let json        = JSON(data)
        title           = json["title"].string
        url             = json["url"].string
        thumbnailUrl    = json["thumbnailUrl"].string
        id              = json["id"].string
    }
}
