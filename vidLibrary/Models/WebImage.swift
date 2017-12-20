//
//  CardImage.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import SwiftyJSON

//CardImages Model
class WebImage: JSONMapper {
    
    let url     : String?
    let h       : Int?
    let w       : Int?
    
    required init(data: Any) {
        let json    = JSON(data)
        url         = json["url"].string
        h           = json["h"].int
        w           = json["w"].int
    }
}

