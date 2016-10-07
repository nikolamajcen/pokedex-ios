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
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["species.name"]
        name = formatName(name: name)
        
        url <- map["species.url"]
        identifier = Int(NSURL(string: url)!.absoluteURL!.lastPathComponent)!
    }
    
    private func formatName(name: String) -> String {
        let startIndex = name.startIndex
        let endIndex = name.index(name.startIndex, offsetBy: 1)
        let firstLetter = String(name.characters.first! as Character).uppercased()
        return name.replacingCharacters(in: startIndex..<endIndex, with: firstLetter)
    }
}
