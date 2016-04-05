//
//  Pokemon.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class Pokemon: NSObject, Mappable {
    
    var url: NSURL?
    var id: Int?
    var name: String?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.url <- (map["url"], URLTransform())
        self.id = Int((url?.absoluteURL.lastPathComponent)!)!
        self.name <- map["name"]
    }
    
}