//
//  Director.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import SwiftyJSON

//Person Model
class Person: JSONMapper {

    let name     : String?
    
    required init(data: Any) {
        let json     = JSON(data)
        name         = json["name"].string
    }
}
