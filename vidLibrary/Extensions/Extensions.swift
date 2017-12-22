//
//  Extensions.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import SwiftyJSON

//Extension for thirdparty SwiftyJSON
extension JSON {
    
    //https://github.com/SwiftyJSON/SwiftyJSON/issues/714
    //this extension will work to match json array of objects into model
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONMapper.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(data: obj)
                    arrObject.append(object)
                }
                return arrObject
            } else {
                let object = baseObj.init(data: self)
                return object
            }
        }
        return nil
    }
}
