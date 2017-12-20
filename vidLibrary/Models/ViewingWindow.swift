//
//  ViewingWindow.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import SwiftyJSON

//ViewWindow Model
class ViewingWindow: JSONMapper {
    
    let startDate           : String?
    let wayToWatch          : String?
    
    required init(data: Any) {
        let json            = JSON(data)
        startDate           = json["startDate"].string
        wayToWatch          = json["wayToWatch"].string
        
    }
}
