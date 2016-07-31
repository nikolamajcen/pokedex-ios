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
    var types: [PokemonType]?
    var descriptionInfo: PokemonDescription?
    var evolutionChain: PokemonEvolutionChain?
    var stats: [PokemonStat]?
    
    required init?(_ map: Map) { }
    
    func mapping(map: Map) {
        evolutionChain = PokemonEvolutionChain()
        
        url <- (map["url"], URLTransform())

        if url != nil {
            id = Int((url?.absoluteURL.lastPathComponent)!)!
        } else {
            id <- map["id"]
        }
        
        name <- map["name"]
        name = formatName(name!)
        
        types <- map["types"]
        types = types?.reverse()
        
        stats <- map["stats"]
        stats = stats?.reverse()
    }
    
    func getListImageName() -> String {
        let number: String
        if id < 10 {
            number = "00\(id!)"
        } else if id < 100 {
            number = "0\(id!)"
        } else {
            number = "\(id!)"
        }
        return "P\(number)S"
    }
    
    private func formatName(name: String) -> String {
        var formattedName = formatFirstLetterToUppercase(name)
        
        if isGenderSpecified() == true {
            formattedName = addGenderSign(formattedName)
        }
        return formattedName
    }
    
    private func formatFirstLetterToUppercase(name: String) -> String {
        let startIndex = name.startIndex
        let endIndex = name.startIndex
        let firstLetter = String(name.characters.first! as Character).uppercaseString
        return name.stringByReplacingCharactersInRange(startIndex...endIndex, withString: firstLetter)
    }
    
    private func isGenderSpecified() -> Bool {
        return id == 29 || id == 32
    }
    
    private func addGenderSign(name: String) -> String {
        let startIndex = name.endIndex.advancedBy(-2)
        let endIndex = name.endIndex.predecessor()
        
        let sign: String
        switch self.id! {
        case 29:
            sign = "♀"
        case 32:
            sign = "♂"
        default:
            sign = ""
        }
        return name.stringByReplacingCharactersInRange(startIndex...endIndex, withString: sign)
    }
}