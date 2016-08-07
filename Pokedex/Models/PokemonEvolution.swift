//
//  PokemonEvolution.swift
//  Pokedex
//
//  Created by Nikola Majcen on 08/05/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper

class PokemonEvolution: NSObject, Mappable {
    
    var identifier = 0
    var name = ""
    var url = ""
    
    override init() {
        super.init()
    }
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        name <- map["species.name"]
        name = formatName(name)
        
        url <- map["species.url"]
        identifier = Int(NSURL(string: url)!.absoluteURL.lastPathComponent!)!
    }
    
    private func formatName(name: String) -> String {
        let startIndex = name.startIndex
        let endIndex = name.startIndex
        let firstLetter = String(name.characters.first! as Character).uppercaseString
        return name.stringByReplacingCharactersInRange(startIndex...endIndex, withString: firstLetter)
    }
}