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
    
    var version: String?
    var text: String?
    var language: String?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.version <- map["version.name"]
        self.text <- map["flavor_text"]
        self.language <- map["language.name"]
    }
}