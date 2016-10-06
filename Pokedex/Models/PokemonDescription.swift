//
//  PokemonDescription.swift
//  Pokedex
//
//  Created by Nikola Majcen on 02/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class PokemonDescription: NSObject, Mappable {
    
    var version = ""
    var text = ""
    var language = ""
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        version <- map["version.name"]
        text <- map["flavor_text"]
        language <- map["language.name"]
    }
}
