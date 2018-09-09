//
//  CardImage.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation
import SwiftyJSON

//CardImages Model
struct WebImage: JSONMapper {
    
    let url     : String?
    let h       : Int?
    let w       : Int?
    
    init(data: Any) {
        let json    = JSON(data)
        url         = json["url"].string
        h           = json["h"].int
        w           = json["w"].int
    }
    
//    func toDictionary() -> [String:Any] {
//        var dict = [String:Any]()
//        let otherSelf = Mirror(reflecting: self)
//        for child in otherSelf.children {
//            if let key = child.label {
//                if let value = child.value as? String {
//                    dict[key] = value
//                }
//                else if let value = child.value as? Int {
//                    dict[key] = value
//                }
//                else {
//                    dict[key] = "--"
//                }
//            }
//        }
//        return dict
//    }
}

