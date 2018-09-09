//
//  ViewingWindow.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation
import SwiftyJSON

//ViewWindow Model
struct ViewingWindow: JSONMapper {
    
    let startDate           : String?
    let wayToWatch          : String?
    
    init(data: Any) {
        let json            = JSON(data)
        startDate           = json["startDate"].string
        wayToWatch          = json["wayToWatch"].string
        
    }
}
