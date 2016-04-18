//
//  Type.swift
//  Pokedex
//
//  Created by Nikola Majcen on 18/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class PokemonType: NSObject, Mappable {
    
    var name: String?
    var url: NSURL?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.name <- map["type.name"]
        self.url <- (map["type.url"], URLTransform())
    }
}