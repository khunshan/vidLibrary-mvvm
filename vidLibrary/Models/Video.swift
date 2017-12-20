//
//  Video.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import SwiftyJSON

class Video: JSONMapper {

    let title        : String?
    let type         : String?
    let url          : String?
    let alternatives : [Alternative]?
    
    required init(data: Any) {
        let json    = JSON(data)
        title       = json["title"].string
        type        = json["type"].string
        url         = json["url"].string
        
        if let arrayData = JSON(json["alternatives"]).to(type: Alternative.self) { //Array of Object
            alternatives       = arrayData as? [Alternative] } else { alternatives = [] }
    }
}


class Alternative: JSONMapper {

    let quality     : String?
    let url         : String?
    
    required init(data: Any) {
        let json    = JSON(data)
        quality     = json["quality"].string
        url         = json["url"].string
    }
}
