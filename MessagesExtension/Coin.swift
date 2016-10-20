//
//  Coin.swift
//  Coin
//
//  Created by Tim Rayle on 9/29/16.
//  Copyright © 2016 Knoable. All rights reserved.
//

import Foundation
import Messages

struct Coin {
    // MARK: Properties
    
    var heads: Bool = arc4random() % 2 == 0
    var call: Bool?
    static let flipString = "Flip"
    
    var isComplete: Bool {
        return call != nil
    }
    var calledIt: Bool {
        return heads == call
    }
}

// Extends `Coin` to be able to be represented by and created with an array of
// `URLQueryItem`s.

extension Coin {
    // MARK: Computed properties
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        let item = URLQueryItem(name: Coin.flipString, value: heads.description)
        items.append(item)
        
        return items
    }
    
    // MARK: Initialization
    
    init?(queryItems: [URLQueryItem]) {
        var heads: Bool = true
        
        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }
            
            if let flip = Bool(value), queryItem.name == Coin.flipString {
                heads = flip
            }
        }
        
        self.heads = heads
    }
}


// Extends `Coin` to be able to be created with the contents of an `MSMessage`.

extension Coin {
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
}

