//
//  Constants.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/22/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation

enum SegIndex: Int {
    case all = 0
    case favorite
}

struct Constants {
    static let kFavoriteChildFirebaseKey = "favorite-movies"
    static let kNoImage = "noImage"
}

