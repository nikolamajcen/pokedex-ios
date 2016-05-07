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
    
    var identifier: Int?
    var name: String?
    var url: NSURL?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        self.name <- map["species.name"]
        self.url <- (map["species.url"], URLTransform())
        
        self.identifier = Int((self.url?.absoluteURL.lastPathComponent)!)!
        makeFirstLetterInNameUppercase()
    }
    
    private func makeFirstLetterInNameUppercase() -> Void {
        let startIndex = self.name!.startIndex
        let endIndex = self.name!.startIndex
        let firstLetterUppercase = String(self.name!.characters.first! as Character).uppercaseString
        self.name!.replaceRange(startIndex...endIndex, with: firstLetterUppercase)
    }
}