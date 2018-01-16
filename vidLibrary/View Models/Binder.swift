//
//  Binder.swift
//  vidLibrary
//
//  Created by khunshan on 16/01/2018.
//  Copyright © 2018 Khunshan Ahmad. All rights reserved.
//

import Foundation

class Binder<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
