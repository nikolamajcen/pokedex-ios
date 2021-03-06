//
//  Pokemon.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Pokemon: Object, Mappable {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var url = ""
    dynamic var types: [PokemonType]?
    dynamic var descriptionInfo: PokemonDescription?
    dynamic var evolutionChain: PokemonEvolutionChain?
    dynamic var stats: [PokemonStat]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["url", "types", "descriptionInfo", "evolutionChain", "stats"]
    }
    
    func mapping(map: Map) {
        evolutionChain = PokemonEvolutionChain()
        
        url <- map["url"]

        if url.isEmpty == false {
            id = Int((NSURL(string: url)!.absoluteURL?.lastPathComponent)!)!
        } else {
            id <- map["id"]
        }
        
        name <- map["name"]
        name = formatName(name: name)
        
        types <- map["types"]
        types = types?.reversed()
        
        stats <- map["stats"]
        stats = stats?.reversed()
    }
    
    func getListImageName() -> String {
        let number: String
        if id < 10 {
            number = "00\(id)"
        } else if id < 100 {
            number = "0\(id)"
        } else {
            number = "\(id)"
        }
        return "P\(number)S"
    }
    
    private func formatName(name: String) -> String {
        var formattedName = formatFirstLetterToUppercase(name: name)
        
        if isGenderSpecified() == true {
            formattedName = addGenderSign(name: formattedName)
        }
        return formattedName
    }
    
    private func formatFirstLetterToUppercase(name: String) -> String {
        let startIndex = name.startIndex
        let endIndex = name.index(name.startIndex, offsetBy: 1)
        let firstLetter = String(name.characters.first! as Character).uppercased()
        return name.replacingCharacters(in: startIndex..<endIndex, with: firstLetter)
    }
    
    private func isGenderSpecified() -> Bool {
        return id == 29 || id == 32
    }
    
    private func addGenderSign(name: String) -> String {
        let startIndex = name.index(name.endIndex, offsetBy: -2)
        let endIndex = name.endIndex
        
        let sign: String
        switch id {
        case 29:
            sign = "♀"
        case 32:
            sign = "♂"
        default:
            sign = ""
        }
        return name.replacingCharacters(in: startIndex..<endIndex, with: sign)
    }
}
