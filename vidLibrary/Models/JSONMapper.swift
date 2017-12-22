//
//  JSONMapper.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/21/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation

//JSONMapper protocol is useful for Model objects initialized with JSON data to be mapped with properties..
protocol JSONMapper {
    init(data: Any)
    //func toDictionary() -> [String:Any]
}

extension JSONMapper {
    //Converts Object to Dictionary using Mirror library of Swift. i.e. Mirror.child, Mirrr.label, Mirrr.value
    func toDictionary() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            
            if let key = child.label {
                
                if let value = child.value as? String {
                    dict[key] = value
                }
                else if let value = child.value as? Int {
                    dict[key] = value
                }
                else if let value = child.value as? [JSONMapper] {
                    var arr = [Any]()
                    for v in value {
                        arr.append(v.toDictionary())
                    }
                    dict[key] = arr
                }
                else if let value = child.value as? JSONMapper {
                    let v = value.toDictionary()
                    dict[key] = v
                }
                //else {
                //  dict[key] = ""
                //}
            }
        }
        return dict
    }
}

